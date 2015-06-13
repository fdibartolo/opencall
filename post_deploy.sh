#!/bin/bash

if [ $TRAVIS_BRANCH == "master" ]; then
	heroku_app=opencall
fi

if [ $TRAVIS_BRANCH == "develop" ]; then
	heroku_app=opencallstage
fi

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
git remote add heroku git@heroku.com:$heroku_app.git
echo "Host heroku.com" >> ~/.ssh/config
echo "   StrictHostKeyChecking no" >> ~/.ssh/config
echo "   CheckHostIP no" >> ~/.ssh/config
echo "   UserKnownHostsFile=/dev/null" >> ~/.ssh/config

heroku keys:clear  
yes | heroku keys:add


heroku config:set commit_id=$TRAVIS_COMMIT