#/bin/bash
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

/Users/martin/source/martinliu-hugo
hugo
rsync -aPv /Users/martin/source/martinliu-hugo/public/   /Users/martin/source/martinliu.github.io/
cd  /Users/martin/source/martinliu.github.io/
git add .
git commit -m "add 2 bps"
git push

