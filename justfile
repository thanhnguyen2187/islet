new-env:
    cp .sample.env .env

build-site:
    cd site && hugo

update-site-remote:
    scripts/update-site-remote.sh

serve-site:
    cd site && hugo server -D

open-site:
    xdg-open http://localhost:1313

open-site-production:
    xdg-open https://nguyenhuythanh.com

commit-site MESSAGE:
    cd site && git add . && git commit -m "{{MESSAGE}}"

push-site:
    cd site && git push && git checkout master
