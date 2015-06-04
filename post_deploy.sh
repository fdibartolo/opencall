#!/bin/bash

if [ $TRAVIS_BRANCH == "master" ]; then
	heroku_app=opencall
fi

if [ $TRAVIS_BRANCH == "develop" ]; then
	heroku_app=opencallstage
fi

heroku config:set commit_id=$TRAVIS_COMMIT --app $heroku_app