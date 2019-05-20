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
