#!/bin/bash

COV_FILE_NAME=$1
APP_PACKAGE_NAME=$2
CLASS_FILES=$3

EC_DIR=~/fuzzingandroid/output/ec_files
JACOCO_DIR=~/fuzzingandroid/jacoco_jars
# Note: jacoco does not know the "~" symbol in file path, so just use the absolute path
#CLASS_FILES=/root/fuzzingandroid/apps/tasks/app/build/intermediates/javac/amazonDebug/classes/

adb shell am broadcast -a edu.gatech.m3.emma.COLLECT_COVERAGE
#adb shell 'su -c "mv /data/data/org.tasks.debug/files/coverage.ec /sdcard/"'
echo "---"
echo "[COVERAGE FILE EXIST?]"
adb shell 'su -c '\""ls /data/data/${APP_PACKAGE_NAME}/files/\""''
echo "---"
adb shell 'su -c '\""mv /data/data/${APP_PACKAGE_NAME}/files/coverage.ec /sdcard/\""''
adb pull /sdcard/coverage.ec

cmd="java -jar $JACOCO_DIR/jacococli.jar report coverage.ec --classfiles $CLASS_FILES &> temp"
echo "---"
echo "[VALIDATE COVERAGE FILE]$ $cmd"
echo "---"

# java -jar ~/Projs/app-coverage-analysis/DroidMutator/droidbot/resources/jacococli.jar report coverage.ec --classfiles ./app/build/intermediates/javac/amazonDebug/classes/ --xml tasks.coverage.xml
java -jar $JACOCO_DIR/jacococli.jar report coverage.ec --classfiles $CLASS_FILES &> temp

echo "---"
echo "[VALIDATE MESSAGE]"
cat temp
echo "---"


if grep -q -i "Exception" temp
then
    echo "ERROR - removing invalid coverage.ec"
    rm coverage.ec
    adb shell 'su -c '\""rm /data/data/${APP_PACKAGE_NAME}/files/coverage.ec\""''
else
    echo "SUCCESS: coverage file is valid!"
    mkdir -p "${EC_DIR}"
    mv coverage.ec $EC_DIR/$COV_FILE_NAME.ec
fi
