new-env:
    cp .sample.env .env

build-site:
    cd site && hugo

update-site-remotely:
    scripts/update-site-remotely.sh

serve-static-page:
    cd site && hugo server -D
