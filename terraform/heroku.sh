#!/bin/bash

REMOTE=$1
GIT_URL=$2
BRANCH=$3

if [ -z $(git config remote.$REMOTE.url) ]; then
  echo 'Adding app as a git remote...'
  git remote add $REMOTE $GIT_URL
fi

git push $REMOTE $BRANCH:master

# schema migrations and setup
heroku run rake db:migrate --app $REMOTE
heroku run rake db:seed --app $REMOTE
