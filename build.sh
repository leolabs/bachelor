#!/bin/sh

mkdir -p output

docker run --rm -i --user="$(id -u):$(id -g)" --net=none \
  -v "$PWD/src":/src -v "$PWD/output":/output "leolabs/pandoc-latex"
