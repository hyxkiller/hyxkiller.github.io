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

- rsync -rv --delete -e 'ssh -o stricthostkeychecking=no -p 80' public/ root@http://39.97.40.43:/usr/local/nginx/
# scp -o stricthostkeychecking=no -P 80 -r public/* root@39.97.40.43:/usr/local/nginx/