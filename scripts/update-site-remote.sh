#!/bin/bash

ssh -tt "$USER@$HOST" << ENDSSH
cd $ISLET_DIR
git pull
git submodule update --remote
cd site && git pull
cd ..
just build-site
docker-compose up -d --force-recreate 
ENDSSH
