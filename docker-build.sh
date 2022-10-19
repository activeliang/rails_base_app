#!/bin/bash
build_opts="--platform linux/amd64" # building at M1 mac for linux
# RAILS_ENV=production docker buildx build $build_opts --no-cache -t activeliang/rails_base_app -f ./.docker/Dockerfile .
# RAILS_ENV=production sudo docker buildx build ./ --platform linux/amd64 --load -t activeliang/rails_base_app -f ./.docker/Dockerfile
RAILS_ENV=production docker build ./ --platform linux/amd64 -t activeliang/myapp-web -f ./.docker/Dockerfile --build-arg RAILS_ENV=production --progress=plain


# --progress=plain


# You can add your push command here, such as:
# docker push ...
# docker push activeliang/rails_base_app-web




# RAILS_ENV=production docker build ./ -t rails_base_app-web -f ./.docker/Dockerfile --build-arg RAILS_ENV=production --progress=plain