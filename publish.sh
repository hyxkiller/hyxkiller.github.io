#!/bin/bash
set -ev

# get clone master
git clone https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master
cd ../
mv .deploy_git/.git/ ./public/
cd ./public
git config user.name "hyxkiller"
git config user.email "546495041@qq.com"

# add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"

# Github Pages
git push --force --quiet "https://${GIT_REPO}@${GH_REF}" master:master

yum -y install sshpass
sshpass -e ssh  -o stricthostkeychecking=no root@39.97.40.43
# ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@39.97.40.43
rm -f /usr/local/nginx/public/
cd /usr/local/nginx/
git clone https://${GIT_REPO}@${GH_REF} master
# ssh -p 22 root@39.97.40.43 'rm -f /usr/local/nginx/public' 
# scp -r -P 22 ./public/* root@39.97.40.43:/usr/local/nginx/public
# rsync -rv --delete -e 'ssh -o stricthostkeychecking=no -p 80' public/ root@http://39.97.40.43:/usr/local/nginx/
# rsync -r --delete-after --quiet /usr/local/nginx/ root@39.97.40.43:/usr/local/nginx/public
# scp -o stricthostkeychecking=no -P 22 -r public/* root@39.97.40.43:/usr/local/nginx/
