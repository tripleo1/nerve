#!/bin/bash

echo "==> Cleaning HTML..."; rm -rfv *.html;
echo "==> Cleaning DIRS..."; rm -rfv author category pages tag theme;
echo "==> Generating content with Docker...";
docker run -it --rm --name=pelican -v $PWD:/home/iaroki/blog iaroki/pelican content;
echo "==> Cleaning cache..."; rm -rfv __pycache__;
echo "==> DONE!"
