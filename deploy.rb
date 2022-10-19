#!/usr/bin/env ruby

p 'build docker_app'
`RAILS_ENV=production docker build ./ --platform linux/amd64 -t activeliang/myapp -f ./.docker/Dockerfile --build-arg RAILS_ENV=production`

p 'push docker_app'
`docker push activeliang/myapp`

p 'update docker-compose.yml'
`scp docker-compose-production.yml root@178.128.214.6:/home/docker/myapp.yml`

p 'pull Image from Docker Hub'
`ssh root@178.128.214.6  'docker pull activeliang/myapp'`

p 'remote docker-compose up'
`ssh root@178.128.214.6  'cd /home/docker && RAILS_ENV=production docker-compose up -f /home/docker/myapp.yml'`