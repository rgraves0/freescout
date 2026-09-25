FROM php:8.2-apache

# လိုအပ်သော PHP Extensions များနှင့် Tools များ ထည့်သွင်းခြင်း
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    libc-client-dev \
    libkrb5-dev \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install pdo pdo_mysql gd zip imap pcntl

# Apache mod_rewrite ဖွင့်ခြင်း
RUN a2enmod rewrite

# DocumentRoot ကို FreeScout ရဲ့ public folder သို့ ချိန်ပေးခြင်း
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Code များကို ကူးထည့်ခြင်း
WORKDIR /var/www/html
COPY . .

# Folder permissions သတ်မှတ်ခြင်း
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["apache2-foreground"]
