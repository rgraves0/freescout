FROM php:8.2-apache

# PHP Extension Installer ထည့်သွင်းခြင်း
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# FreeScout အတွက် လိုအပ်သော PHP Extensions များ install လုပ်ခြင်း
RUN install-php-extensions pdo_mysql gd zip imap pcntl intl opcache

# လိုအပ်သော CLI tools များ ထည့်သွင်းခြင်း
RUN apt-get update && apt-get install -y git unzip zip && rm -rf /var/lib/apt/lists/*

# Apache mod_rewrite ဖွင့်ခြင်း
RUN a2enmod rewrite

# DocumentRoot ကို FreeScout ရဲ့ public directory သို့ ချိန်ပေးခြင်း
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html
COPY . .

# Permissions သတ်မှတ်ခြင်း
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["apache2-foreground"]
