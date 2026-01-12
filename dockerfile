# ---------- FRONTEND BUILD ----------
FROM node:18 AS frontend
WORKDIR /app

COPY package*.json ./
RUN npm ci   # faster & more reliable than npm install

COPY . .
RUN npm run build \
    && ls -la public/build   # ← debug: see if manifest.json exists

# ---------- BACKEND ----------
FROM php:8.2-cli

# ... (your existing apt & extensions)

WORKDIR /var/www

COPY composer*.json ./
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

COPY . .

# Fix permissions EARLY
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache \
    && mkdir -p public/build && chown -R www-data:www-data public/build

# Copy assets + verify
COPY --from=frontend --chown=www-data:www-data /app/public/build ./public/build

RUN ls -la public/build   # ← debug in build logs: must show manifest.json + assets

# Caches – ignore failures
RUN php artisan config:cache || true \
    && php artisan route:cache || true \
    && php artisan view:cache || true

# Migrations optional – but safe with || true
RUN php artisan migrate --force || true

CMD php -S 0.0.0.0:$PORT -t public
