#!/bin/sh

php artisan key:generate

composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

php artisan migrate

npm install

npm run build


