---
title: "DevOps登山指南手册"
date: 2018-02-20T00:34:09+08:00
draft: false
description: " 案例研究 DOES17 San Francisco - DevOps Handbook Experiments in Accelerating Delivery - Nationwide"
subtitle: "美国金融行业Nationwide保险公司DevOps案例研究，来源DOES17 San Francisco，主题-DevOps Handbook Experiments in Accelerating Delivery"
tags: ["DevOps"]
bigimg: [{src: "https://res.cloudinary.com/martinliu/image/upload/q_auto:eco/abstract-6.jpg", desc: "DevOps案例研究-Nationwide使用DevOps Handbook在加速交付过程中的实验"}]
postmeta: false
nocomment: true
---

全美互惠保险公司(Nationwide)，美国公司。2017年6月7日，2017年《财富》美国500强排行榜发布，全美互惠保险公司排名第68位。营业收入40074.1百万美元。

这家公司是DevOps Handbook（DevOps实践指南）书中的案例研究之一。这是一家DevOps水平较高的公司，是DevOpsDays大会的常客，是DevOps工具厂商（New Relic）常会邀请的技术大会的案例分享嘉宾。他们也经常参加DevOps企业峰会，多次做过自身DevOps应用状况的案例分享，本文参考了他们在2017年11月旧金山站DevOps企业峰会上他们的分享演讲，主题为《DevOps Handbook Experiments in Accelerating Delivery - Nationwide》（使用DevOps Handbook在加速发交付的过程中的实验）

本文根据这个分享演讲的YouTube视频整理而成。视频已经上传到腾讯视频，观看地址点这里。

## DevOps登山指南手册

在翻译DevOps Handbook的过程中，这家公司的案例研究，并不像本文所提到的这个演讲的这般的精彩。凭借记忆，回忆书中的案例研究大概谈的了几点：

* 他们多次参加DevOpsDays社区的活动之后，受到启发和鼓舞。
* 然后在自己的公司里也举办了同样风格的大会，首次大会邀请的多是外部分享嘉宾，目标是在企业内部，给他们的领导创造一个近似于参加外部DevOpsDays大会体验。
* 取得的效果很明显和实际，通过这次大会领导层对DevOps获得了充分的认识，并开始提供这方面的支持。

上面的这个案例的目标是描述组织性学习和创建学习型组织的方式和方法。

而时光已经很快的流转到了将近2018年，进过多年DevOps的发展和演进，这个案例向我们展示了一个金融行业（我们往往认为不太容易实施DevOps的行业）的企业，在很大的规模上，所取得的令人敬佩的成就。

下面这张图是我从他们的材料里分析和整理的。他们使用了攀登珠穆朗玛峰的比喻，对DevOps实施做了生动的诠释。

![DevOps登山指南手册](https://res.cloudinary.com/martinliu/image/upload/devops-climbing-guide)

本图在Nationwide公司内部的使用场景。

1. 将DevOps实施核心团队所指导和引领的产品线团队（或者可以说是业务团队、服务团队、这样的团队他们有200多个）的经验和讨论都总结在一张纸上，方便其它有实施DevOps实践想法的团队参考。
2. 该登山指南简化了对小白团队的教育和指引。
3. 他们将DevOps的实施分成了三个阶段，分别用从大本营、北坡营地到顶峰作比喻。
4. 这三个阶段里的技术实践都来自于DevOps Handbook

下面我们从知其然的层面，继续向下发掘，目标是对此案例更加的了解，并知其所以然。接下来详细看下这个案例分享都讲了那些主要内容。

## 主题：DevOps Handbook-在加速交付中的各种实验

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-001.jpg)

这个演讲的发生时间在2017年11月，距现在也就是三个月前。Cindy是DevOps核心团队中的核心人员，她的头衔是Director级别，角色是夏尔巴人，为内部的产品组提供内部的DevOps咨询和辅导。Jim属于业务条线的Dev这一侧，他是业务部门的解决方案架构师。

## Nationwide的核心价值：保护最有价值的

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-002.jpg)

* Nationwide在很多险种上是业内第一名，包括：宠物保险、农场保险、公司寿险等等。
* 这是一家90年的老店
* 汽车保险是排名第八（后面的案例中说的是这个业务）
* 不光在财富500强企业排名68，而且也是财富所评选最佳工作企业前100。

## Nationwide 的IT规模很大

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-003.jpg)

* IT组织庞大，结构复杂，业务条线众多
* 在选择应用某个DevOps实践的时候，总是会同时考虑，是否能将它在200多个业务开发团队上全面推广
* IT人员总数草果5100人，其中程序员和测试人员的数量超过2600人；在电脑世界的IT最佳工作地点的排行帮上位居第51名
* 200多个产品开发团队，服务于23个业务部门

## Nationwide IT的组织架构

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-004.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-005.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-006.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-007.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-008.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-009.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-010.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-011.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-012.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-013.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-014.jpg)

## DevOps

![Grafmeyer, Jim, Payne, Cindy, DevOps Handbook Experiments in Accelerating Delivery](https://res.cloudinary.com/martinliu/image/upload/Grafmeyer_Jim_Payne_Cindy_DevOps_Handbook_Experiments_in_Accelerating_Delivery-page-015.jpg)

## DevOps





