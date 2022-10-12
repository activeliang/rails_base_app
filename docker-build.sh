#!/bin/bash
build_opts="--platform linux/amd64" # building at M1 mac for linux
RAILS_ENV=production docker build $build_opts -t myapp -f ./.docker/Dockerfile .

# You can add your push command here, such as:
# docker push ...
