---
date: 2018-03-24T09:51:28+08:00
title: "在AWS的已有的VPC里用Kops和Terraform部署Kubernetes集群"
subtitle: "如果你已经烦透了每次都从创建虚拟机、配置selinux、禁用swap、安装Docker开始装K8s，那么你需要看看本文"
description: "在AWS的已有的VPC里用Kops和Terraform部署Kubernetes集群"
categories: "DevOps"
tags: ["DevOps","Kubernetes","kops","Terraform"]
keywords: ["DevOps"]
bigimg: [{src: "https://res.cloudinary.com/martinliu/image/upload/abstract-1.jpg", desc: "DevOps"}]
---

[Kops](https://github.com/kubernetes/kops) 是一个相对较新的工具，可用于在AWS上部署生产就绪型 [Kubernetes](https://kubernetes.io/) 群集。它能够创建跨多个可用性区域的高可用性群集，并支持VPC专用网络拓扑。默认情况下，Kops将在AWS上为您创建所有必需的资源—EC2实例、VPC和子网、Route53中所需的DNS条目、用于公开Kubernetes API的负载平衡器以及所有其他必需的基础架构组件。

对于已经使用了Terraform的组织，Kops可以替代地用于为你创建上述所有AWS资源的 [Terraform](https://www.terraform.io/) 配置。这将使他们能够使用熟悉的 `terraform plan` 和 `terraform apply` 工作流来构建和更新Kubernetes基础架构。Kops生成的Terraform配置将包括新的VPC、子网和路由资源。

但是，如果您希望使用Kops在现有VPC中为Kubernetes集群生成Terraform配置，那该怎么办？在本文中，我将介绍实现这一目标的过程。

> 为了完成本文的操作流程，您需要一个域名，您可以在Route53中注册。我们将创建托管区，作为我们初始化Terraform配置的一部分，稍后在本文中介绍。

## 用Terraform创建一个VPC

To simulate this process, we need an existing VPC infrastructure to work with. In the repository associated with this post, I have some Terraform modules that will let us easily create a VPC with public / private subnet pairs across multiple availability zones. It will also create NAT gateways to allow outbound internet traffic for instances on the private subnets.



Let’s create this infrastructure. Go ahead and clone the repository.

要模拟我的实现过程，你需要基于一个现有的VPC基础架构来配合。在与本文相关的代码库中，我有一些Terraform模块，我们可以轻松创建一个跨多个可用性区的具有public / private子网的VPC。它还将创建NAT网关，以允许private子网中实例的出站的internet流量。

让我们创建此基础架构。从克隆我的代码库开始。


```sh
martin@mbp:~/source $ git clone https://github.com/martinliu/kubernetes-aws-vpc-kops-terraform.git
Cloning into 'kubernetes-aws-vpc-kops-terraform'...
remote: Counting objects: 28, done.
remote: Total 28 (delta 0), reused 0 (delta 0), pack-reused 28
Unpacking objects: 100% (28/28), done.
martin@mbp:~/source $
```


在运行 `terraform apply` 之前，需要配置一些变量。 在 `variables.tf` 文件中，你需要设置域名变量。 它会在配置中多次用到，这是我们访问这个k8s群集的域名。要么直接修改tf文件中的变量，要么在运行的时候设置这个变量。我在代码中使用二级域名： k8s.devopscoach.org ；



还可以配置区域和可用性区域变量。我在代码中设置的是两个可用区： "ap-northeast-1a", "ap-northeast-1c"。如果需要，还可以配置环境变量和VPC_CIDR变量。


> Tip: 找出你所在Region的AZ有哪些，使用用这个命令： `aws ec2 describe-availability-zones --region ap-northeast-1 `。 替换. `us-east-1` 为你想查询的Region。

参考一下操作命令，安装必要的 `kubectl kops terraform awscli `工具。

```sh
brew update && brew install kubectl
brew install terraform
brew install kops
brew install awscli
aws configure

aws ec2 describe-availability-zones --region ap-northeast-1
{
    "AvailabilityZones": [
        {
            "State": "available",
            "Messages": [],
            "RegionName": "ap-northeast-1",
            "ZoneName": "ap-northeast-1a"
        },
        {
            "State": "available",
            "Messages": [],
            "RegionName": "ap-northeast-1",
            "ZoneName": "ap-northeast-1c"
        },
        {
            "State": "available",
            "Messages": [],
            "RegionName": "ap-northeast-1",
            "ZoneName": "ap-northeast-1d"
        }
    ]
}
```

export AWS_ACCESS_KEY_ID=<access key>
export AWS_SECRET_ACCESS_KEY=<secret key>

terraform get
terraform apply


Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

availability_zones = [
    ap-northeast-1a,
    ap-northeast-1c,
    ap-northeast-1d
]
cluster_name = staging.k8s.devopscoach.org
name = k8s.devopscoach.org
name_servers = [
    ns-118.awsdns-14.com,
    ns-1292.awsdns-33.org,
    ns-1986.awsdns-56.co.uk,
    ns-621.awsdns-13.net
]
nat_gateway_ids = [
    nat-0ca36781db0154fd4,
    nat-089d41496950f827b,
    nat-00ca155333eb37fea
]
private_subnet_ids = [
    subnet-fb5f7bb2,
    subnet-458f1e1e,
    subnet-c9f0c3e1
]
public_subnet_ids = [
    subnet-565e7a1f,
    subnet-438f1e18,
    subnet-daf4c7f2
]
public_zone_id = Z3OM8TWJC71MC6
state_store = s3://k8s.devopscoach.org-state
vpc_id = vpc-4c3eb12b



export NAME=$(terraform output cluster_name)
export KOPS_STATE_STORE=$(terraform output state_store)
export ZONES=ap-northeast-1a,ap-northeast-1c,ap-northeast-1d



martin@mbp:source/kubernetes-aws-vpc-kops-terraform ‹master*›$ expoexport NAME=$(terraform output cluster_name)
export KOPS_STATE_STORE=$(terraform output state_store)
export ZONES=ap-northeast-1a,ap-northeast-1c,ap-northeast-1d
martin@mbp:source/kubernetes-aws-vpc-kops-terraform ‹master*›$ echo $NAME
staging.k8s.devopscoach.org
martin@mbp:source/kubernetes-aws-vpc-kops-terraform ‹master*›$  echo $KOPS_STATE_STORE
s3://k8s.devopscoach.org-state
martin@mbp:source/kubernetes-aws-vpc-kops-terraform ‹master*›$ expoexport ZONES=$(terraform output -json availability_zones | jq -r '.value|join(",")')
martin@mbp:source/kubernetes-aws-vpc-kops-terraform ‹master*›$ echo $ZONES
ap-northeast-1a,ap-northeast-1c,ap-northeast-1d




martin@mbp:source/kubernetes-aws-vpc-kops-terraform ‹master*›$ kops create cluster \
    --master-zones $ZONES \
    --zones $ZONES \
    --topology private \
    --dns-zone $(terraform output public_zone_id) \
    --networking calico \
    --vpc $(terraform output vpc_id) \
    --target=terraform \
    --out=. \
    ${NAME}
I0327 08:32:33.302984    8435 create_cluster.go:439] Inferred --cloud=aws from zone "ap-northeast-1a"
I0327 08:32:33.304088    8435 create_cluster.go:971] Using SSH public key: /Users/martin/.ssh/id_rsa.pub
I0327 08:32:39.265784    8435 subnets.go:184] Assigned CIDR 10.20.32.0/19 to subnet ap-northeast-1a
I0327 08:32:39.265833    8435 subnets.go:184] Assigned CIDR 10.20.64.0/19 to subnet ap-northeast-1c
I0327 08:32:39.265844    8435 subnets.go:184] Assigned CIDR 10.20.96.0/19 to subnet ap-northeast-1d
I0327 08:32:39.265855    8435 subnets.go:198] Assigned CIDR 10.20.0.0/22 to subnet utility-ap-northeast-1a
I0327 08:32:39.265867    8435 subnets.go:198] Assigned CIDR 10.20.4.0/22 to subnet utility-ap-northeast-1c
I0327 08:32:39.265877    8435 subnets.go:198] Assigned CIDR 10.20.8.0/22 to subnet utility-ap-northeast-1d
W0327 08:33:07.678863    8435 firewall.go:228] Opening etcd port on masters for access from the nodes, for calico.  This is unsafe in untrusted environments.
I0327 08:33:14.748194    8435 executor.go:91] Tasks: 0 done / 113 total; 37 can run
I0327 08:33:14.754004    8435 dnszone.go:242] Check for existing route53 zone to re-use with name ""
I0327 08:33:16.322522    8435 dnszone.go:249] Existing zone "devopscoach.org." found; will configure TF to reuse
I0327 08:33:18.205938    8435 vfs_castore.go:435] Issuing new certificate: "apiserver-aggregator-ca"
I0327 08:33:18.441716    8435 vfs_castore.go:435] Issuing new certificate: "ca"
I0327 08:33:25.398613    8435 executor.go:91] Tasks: 37 done / 113 total; 32 can run
I0327 08:33:28.824769    8435 vfs_castore.go:435] Issuing new certificate: "master"
I0327 08:33:29.289583    8435 vfs_castore.go:435] Issuing new certificate: "kube-scheduler"
I0327 08:33:29.364250    8435 vfs_castore.go:435] Issuing new certificate: "apiserver-aggregator"
I0327 08:33:29.813832    8435 vfs_castore.go:435] Issuing new certificate: "kops"
I0327 08:33:29.994237    8435 vfs_castore.go:435] Issuing new certificate: "kube-controller-manager"
I0327 08:33:30.013563    8435 vfs_castore.go:435] Issuing new certificate: "kubelet"
I0327 08:33:30.129416    8435 vfs_castore.go:435] Issuing new certificate: "kubecfg"
I0327 08:33:30.233300    8435 vfs_castore.go:435] Issuing new certificate: "kube-proxy"
I0327 08:33:30.799369    8435 vfs_castore.go:435] Issuing new certificate: "apiserver-proxy-client"
I0327 08:33:30.855873    8435 vfs_castore.go:435] Issuing new certificate: "kubelet-api"
I0327 08:33:36.548898    8435 executor.go:91] Tasks: 69 done / 113 total; 30 can run
I0327 08:33:42.802898    8435 executor.go:91] Tasks: 99 done / 113 total; 8 can run
I0327 08:33:42.805755    8435 executor.go:91] Tasks: 107 done / 113 total; 6 can run
I0327 08:33:42.806506    8435 executor.go:91] Tasks: 113 done / 113 total; 0 can run
I0327 08:33:42.824948    8435 target.go:270] Terraform output is in .
I0327 08:33:44.968512    8435 update_cluster.go:248] Exporting kubecfg for cluster
kops has set your kubectl context to staging.devopscoach.org

Terraform output has been placed into .
Run these commands to apply the configuration:
   cd .
   terraform plan
   terraform apply

Suggestions:
 * validate cluster: kops validate cluster
 * list nodes: kubectl get nodes --show-labels
 * ssh to the master: ssh -i ~/.ssh/id_rsa admin@api.staging.devopscoach.org
The admin user is specific to Debian. If not using Debian please use the appropriate user based on your OS.
 * read about installing addons: https://github.com/kubernetes/kops/blob/master/docs/addons.md

 
 martin@mbp:source/kubernetes-aws-vpc-kops-terraform ‹master*›$ kops update cluster \
  --out=. \
  --target=terraform \
  ${NAME}
W0327 08:36:44.488305    8565 firewall.go:228] Opening etcd port on masters for access from the nodes, for calico.  This is unsafe in untrusted environments.
I0327 08:36:52.560873    8565 executor.go:91] Tasks: 0 done / 113 total; 37 can run
I0327 08:36:52.564159    8565 dnszone.go:242] Check for existing route53 zone to re-use with name ""
I0327 08:36:54.718293    8565 dnszone.go:249] Existing zone "devopscoach.org." found; will configure TF to reuse
I0327 08:36:59.122273    8565 executor.go:91] Tasks: 37 done / 113 total; 32 can run
I0327 08:37:06.483161    8565 executor.go:91] Tasks: 69 done / 113 total; 30 can run
I0327 08:37:11.132301    8565 executor.go:91] Tasks: 99 done / 113 total; 8 can run
I0327 08:37:11.134333    8565 executor.go:91] Tasks: 107 done / 113 total; 6 can run
I0327 08:37:11.134786    8565 executor.go:91] Tasks: 113 done / 113 total; 0 can run
I0327 08:37:11.144577    8565 target.go:270] Terraform output is in .
I0327 08:37:15.039854    8565 update_cluster.go:248] Exporting kubecfg for cluster
kops has set your kubectl context to staging.devopscoach.org

Terraform output has been placed into .

Changes may require instances to restart: kops rolling-update cluster

