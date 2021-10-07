#!/bin/bash

echo "==> Cleaning content..."
rm -rfv *.html *.xml about* blog categories code css img links tags
echo "==> Switching into a source directory..."
cd source
echo "==> Generating content with Docker..."
docker run -it --rm --name=hugo -v $PWD:/home/iaroki/blog iaroki/hugo
echo "==> Moving public content..."
mv -v public/* ..
echo "==> DONE!"
