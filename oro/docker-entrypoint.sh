#!/bin/bash
set -e

service php7.1-fpm restart

if ! [ -d $APP_PATH ]; then
     cd $APP_ROOT \
    && git clone -b 1.6 https://github.com/oroinc/orocommerce-application.git $APP_PATH \
    && cd $APP_PATH
    composer install --prefer-dist 
fi

if [ "$SCENARIO" = 'deploy' ]; then

    if [ -f  "$APP_ROOT/parameters.yml" ]; then
    cp $APP_ROOT/parameters.yml $APP_PATH/app/config/parameters.yml
    sed -i -e 's/MYSQL_HOST/'$MYSQL_HOST'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/MYSQL_PORT/'$MYSQL_PORT'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/MYSQL_DATABASE/'$MYSQL_DATABASE'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/MYSQL_USER/'$MYSQL_USER'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/MYSQL_PASSWORD/'$MYSQL_PASSWORD'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/APP_MAILER_TRANSPORT/'$APP_MAILER_TRANSPORT'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/APP_MAILER_HOST/'$APP_MAILER_HOST'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/APP_MAILER_PORT/'$APP_MAILER_PORT'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/APP_MAILER_ENCRYPTION/'$APP_MAILER_ENCRYPTION'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/APP_MAILER_USER/'$APP_MAILER_USER'/g' $APP_PATH/app/config/parameters.yml
    sed -i -e 's/APP_MAILER_PASSWORD/'$APP_MAILER_PASSWORD'/g' $APP_PATH/app/config/parameters.yml
    fi
    
    echo '---------------------------------------------------'
    env
    echo '---------------------------------------------------'
    cd $APP_PATH
    rm -rf app/cache/*
    #php ./app/console cache:clear –-env $APP_ENV
    cp $APP_PATH/app/config/parameters.yml.dist $APP_PATH/app/config/parameters.yml.dist.back
    cp $APP_PATH/app/config/parameters.yml $APP_PATH/app/config/parameters.yml.dist
    php ./app/console oro:install --env=$APP_ENV --timeout=900 --no-debug --application-url="$APP_URL" \
    --organization-name "$APP_ORG" --user-name="$APP_LOGIN" --user-email="$APP_MAIL" --user-firstname="$APP_UFN" --user-lastname="$APP_ULN" --user-password="$APP_PASS" --sample-data=$APP_DEMO
    #php app/console cache:warmup --env=$APP_ENV
    exit 0
 fi

if [ "$SCENARIO" = 'run' ]; then
    #setfacl -b -R ./
    cd $APP_PATH
    find . -type f -exec chmod 0644 {} \;
    find . -type d -exec chmod 0755 {} \;
    #chown -R www-data:www-data ./app/{attachment,cache,import_export,logs}
    #chown -R www-data:www-data ./web/{media,uploads,js}
    chown -R www-data:www-data ./app/
    chown -R www-data:www-data ./web/
    nohup php ./app/console oro:message-queue:consume --env=$APP_ENV &
    nohup php ./app/console clank:server --env=$APP_ENV &
    
fi

/usr/bin/tail -f /dev/null

exec "$@"