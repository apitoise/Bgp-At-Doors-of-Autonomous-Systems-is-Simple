#!/bin/sh

docker build . -t host --target host
docker build . -t router --target router
