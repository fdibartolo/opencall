#!/bin/bash

REMOTE=$1
GIT_URL=$2
BRANCH=$3

git remote remove $REMOTE
git remote add $REMOTE $GIT_URL
git push $REMOTE $BRANCH:master

# schema migrations and setup
heroku run rake db:migrate --app $REMOTE
heroku run rake db:seed --app $REMOTE
