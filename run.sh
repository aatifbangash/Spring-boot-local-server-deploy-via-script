#!/bin/sh

#####live server#####
export JAVA_HOME=/usr/lib/jvm/jdk-17;
export SERVER_PORT=8080
export MASTER_DATASOURCE_NAME=admin_master_whitelabel
export MASTER_DATASOURCE_HOST=172.29.34.00
export MASTER_DATASOURCE_URL=jdbc:mysql://000.29.34.16:3306/admin_master_whitelabel
export MASTER_DATASOURCE_PORT=3306
export MASTER_DATASOURCE_USERNAME='XXXX'
export MASTER_DATASOURCE_PASSWORD='XXXX'
export CLICK_DB=stats
export CLICK_HOST=0000.29.34.54
export CLICK_PORT=27017

export RUNNER_ALLOW_RUNASROOT=1

export AUTH_API_URL=http://google.com
export HUB_SPOT_URL=http://google.com
export AMQP_HOST=localhost
export AMQP_PORT=5672
export AMQP_USERNAME=user
export AMQP_PASSWORD=password
export AMQP_ENABLE_SSL=false
export AUTH_API_URL="SQUIRREL API PATH"
export HUB_SPOT_URL=https://api.hubapi.com/
export HUB_SPOT_KEY=XXXXXXXX
export AWS_ACCESS_KEY_ID=xxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxx

SRC_DIR="/home/actions-runner/orangutan/orangutan/orangutan/"
TARGET_DIR="/home/orangutan_local/orangutan/"
SCRIPT_DIR="/home/orangutan_local/run/"

#####local#####
# SRC_DIR="/var/www/html/orangutan/"
# TARGET_DIR="/var/www/html/orangutan_local/orangutan/"
# SCRIPT_DIR="/var/www/html/orangutan_local/run/"

## STEPS:-
# check code difference between source and target directores
# empty the log.txt file
# stop already running spring boot application
# sync the source folder into the target folder
# start the new deamon or spring boot application in the background and push the logs into the log.txt file
# add the deamon proccessID in the pid.file

IS_DIFF="$(/usr/bin/diff -r -q "$SRC_DIR""src/main/kotlin/" "$TARGET_DIR""src/main/kotlin/")"
if [ ! -z "$IS_DIFF" ]
then
    echo "" > "$SCRIPT_DIR""log.txt" && \
    "$TARGET_DIR""gradlew" --stop -p $TARGET_DIR > "$SCRIPT_DIR""log.txt" 2>&1 && \
    /usr/bin/rsync -au --delete $SRC_DIR $TARGET_DIR && \
    nohup "$TARGET_DIR""gradlew" bootRun -p $TARGET_DIR > "$SCRIPT_DIR""log.txt" 2>&1 & \
    echo $! > "$SCRIPT_DIR""pid.file"
fi
