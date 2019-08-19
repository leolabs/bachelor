#!/bin/sh

mkdir -p output

docker run --rm -i --user="$(id -u):$(id -g)" --net=none \
  -v "$PWD":/github/workspace "leolabs/pandoc-latex"
