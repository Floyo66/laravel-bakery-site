# ---------- Frontend build (Vite + Tailwind) ----------
FROM node:18 AS frontend
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy source and build production assets
COPY . .
RUN npm run build

# ---------- Backend (Laravel) ----------
FROM php:8.2-cli

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

COPY . .

COPY --from=frontend /app/public/build ./public/build

RUN chown -R www-data:www-data storage bootstrap/cache
RUN php artisan optimize:clear || true

CMD php artisan serve --host=0.0.0.0 --port=$PORT
