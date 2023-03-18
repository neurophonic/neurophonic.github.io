#!/bin/zsh

JEKYLL_ENV=production bundle exec jekyll b

server="nathan@192.168.1.23"
# script to build the docker file and sent to server via scp
docker build . -t doc_site --platform=linux/amd64

docker save -o dockerimage/doc_site.tar doc_site

echo "Copy to $server"
scp dockerimage/doc_site.tar $server:~/doc_site/doc_site.tar
scp docker-compose.yml $server:~/doc_site/docker-compose.yml

echo "Run docker on server"

ssh $server 'docker load -i ~/doc_site/doc_site.tar'
ssh $server 'docker-compose -f ~/doc_site/docker-compose.yml up -d --force-recreate'