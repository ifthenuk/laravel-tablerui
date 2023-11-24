#!/bin/sh

composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

npm install

php artisan key:generate

php artisan migrate
