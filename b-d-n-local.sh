sudo docker run  --rm \
  -v $(pwd):/src      \ 
  klakegg/hugo        
sudo sync -aE -delete "./public/" "/usr/share/nginx/html"
