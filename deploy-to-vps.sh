#!/bin/bash

rm -rf /usr/local/nginx/public/
cd /usr/local/nginx/
mkdir public
cd public
git clone https://github.com/hyxkiller/hyxkiller.github.io master