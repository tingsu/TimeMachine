#!/bin/bash

COV_FILE_NAME=$1
APP_PACKAGE_NAME=org.tasks.debug

EC_DIR=~/fuzzingandroid/output/ec_files
JACOCO_DIR=~/fuzzingandroid/jacoco_jars
CLASS_FILES=~/fuzzingandroid/apps/tasks/app/build/intermediates/javac/amazonDebug/classes/

adb shell am broadcast -a edu.gatech.m3.emma.COLLECT_COVERAGE
adb pull /data/data/$APP_PACKAGE_NAME/files/coverage.ec

# java -jar ~/Projs/app-coverage-analysis/DroidMutator/droidbot/resources/jacococli.jar report coverage.ec --classfiles ./app/build/intermediates/javac/amazonDebug/classes/ --xml tasks.coverage.xml
java -jar $JACOCO_DIR/jacococli.jar report coverage.ec --classfiles $CLASS_FILES &> temp

if grep -q -i "Exception" temp
then
    echo "Error - removing invalid coverage.ec"
    rm coverage.ec
    adb shell rm /data/data/$APP_PACKAGE_NAME/files/coverage.ec
else
    echo "ec file is valid!"
    mv coverage.ec $EC_DIR/$COV_FILE_NAME.ec
fi
