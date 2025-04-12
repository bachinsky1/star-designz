#!/bin/bash

set -e

clear

echo -e "Установка и развертывание приложения на Docker..."

read -p "Очистить mysql-data перед запуском? [y/N] " CONFIRM
if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
  echo -e "Удаление ./mysql-data..."
  rm -rf mysql-data
fi

if [ ! -f backend/.env ] && [ -f backend/.env.example ]; then
  echo -e "Копируем .env из .env.example"
  cp backend/.env.example backend/.env
  sed -i 's/DB_HOST=.*/DB_HOST=mysql/' backend/.env
fi

docker compose down
docker compose up -d --build

echo -e "Ждем 30 секунд развертывания MySQL..."
sleep 30

echo -e "Установка PHP-зависимостей Laravel..."
docker compose exec app composer install

echo -e "$INFO Установка прав на storage и cache..."
docker compose exec app chmod -R 775 storage bootstrap/cache
docker compose exec app chown -R www-data:www-data storage bootstrap/cache

echo -e "Генерация ключа приложения..."
docker compose exec app php artisan key:generate

echo -e "Запуск миграций и сидов..."
docker compose exec app php artisan migrate --seed

echo -e "Установка NPM-зависимостей внутри контейнера..."
docker compose exec app sh -c "cd /var/www/html && npm install"

echo -e "Сборка фронтенда Vite..."
docker compose exec app sh -c "cd /var/www/html && npm run build"

echo -e "Контейнеры запущены и проект готов к работе!"
echo -e "Laravel:     http://localhost"
echo -e "phpMyAdmin: http://localhost:8080"
