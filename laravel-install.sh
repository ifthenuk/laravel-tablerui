#!/bin/sh

php artisan key:generate

composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

npm install

php artisan migrate

