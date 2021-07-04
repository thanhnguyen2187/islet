#!/bin/bash

ssh -tt "$USER@$HOST" << ENDSSH
cd $ISLET_DIR
git pull
git submodule update --remote
just build-static-page
docker-compose up -d --force-recreate 
ENDSSH
