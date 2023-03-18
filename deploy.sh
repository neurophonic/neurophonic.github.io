#!/bin/zsh

JEKYLL_ENV=production bundle exec jekyll b

server="nathan@192.168.1.23"
# script to build the docker file and sent to server via scp
docker build . -t test_site --platform=linux/amd64

docker save -o dockerimage/test_site.tar test_site

scp dockerimage/test_site.tar $server:~/test_site/test_site.tar
scp docker-compose.yml $server:~/test_site/docker-compose.yml
echo "Copied to $server"

ssh $server 'docker load -i ~/test_site/test_site.tar'
ssh $server 'docker-compose -f ~/test_site/docker-compose.yml up -d --force-recreate'