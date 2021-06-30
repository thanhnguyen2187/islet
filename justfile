new-env:
    cp .sample.env .env

build-static-page:
    cd site && hugo

serve-static-page:
    cd site && hugo server -D
