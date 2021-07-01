new-env:
    cp .sample.env .env

build-static-page:
    cd site && hugo

push-static-page-image: build-static-page
    cd site && sudo docker build -t thanhnguyen2187/islet-site .
    sudo docker push thanhnguyen2187/islet-site:latest

serve-static-page:
    cd site && hugo server -D

serve-static-page-production:
    cd site && hugo server
