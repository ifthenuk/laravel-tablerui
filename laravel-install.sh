#!/bin/sh
cp .env.example .env

service apache2 restart

php artisan key:generate

composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

php artisan migrate

npm install --legacy-peer-deps

npm run build


