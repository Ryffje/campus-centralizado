# ---------- BUILD STAGE ----------
    FROM node:20-alpine AS node_builder

    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build
    
    
    # ---------- PHP STAGE ----------
    FROM php:8.2-fpm-alpine
    
    # Instalar dependencias necesarias
    RUN apk add --no-cache \
        bash \
        git \
        curl \
        zip \
        unzip \
        oniguruma-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        icu-dev \
        libzip-dev
    
    # Extensiones PHP necesarias para Laravel
    RUN docker-php-ext-install \
        pdo \
        pdo_mysql \
        mbstring \
        zip \
        exif \
        pcntl
    
    # Composer
    COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
    
    WORKDIR /var/www
    
    # Copiar proyecto
    COPY . .
    
    # Copiar build frontend
    COPY --from=node_builder /app/public/build ./public/build
    
    # Instalar dependencias PHP
    RUN composer install --no-dev --optimize-autoloader
    
    # Permisos
    RUN chown -R www-data:www-data storage bootstrap/cache
    
    # Exponer puerto
    EXPOSE 10000
    
    # Comando de inicio
    CMD php artisan config:clear && \
        php artisan route:clear && \
        php artisan migrate --force && \
        php artisan serve --host=0.0.0.0 --port=10000