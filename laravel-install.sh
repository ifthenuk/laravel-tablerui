#!/bin/sh
cp .env.example .env

php artisan key:generate

node --version

npm --version

composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

php artisan migrate

npm install

npm run build


