new-env:
    cp .sample.env .env

build-static-page:
    cd site && hugo

update-static-page: build-static-page
    sudo docker-compose up -d --force-recreate islet-site

serve-static-page:
    cd site && hugo server -D
