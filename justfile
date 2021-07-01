new-env:
    cp .sample.env .env

build-static-page:
    cd site && hugo

update-static-page: build-static-page
    docke

serve-static-page:
    cd site && hugo server -D
