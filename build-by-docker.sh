cd martinliu-hugo
sudo git pull
cd ..
sudo rsync -aE -delete "./martinliu-hugo/" "./src/"

sudo docker run  --rm   -v $(pwd)/src:/src -v $(pwd)/output:/output  --name hugo-server jojomi/hugo:0.53

sudo sync -aE -delete "./output/" "./martinliu.github.io
cd martinliu.github.io
sudo git add .
sudo git commit -m 'update on the aws instence'
sudo git push
