#!/bin/bash

JACOCO_DIR=~/fuzzingandroid/jacoco_jars
EC_DIR=~/fuzzingandroid/output/ec_files
OUTPUT=~/fuzzingandroid/output/
#CLASS_FILES=~/fuzzingandroid/apps/tasks/app/build/intermediates/javac/amazonDebug/classes/
CLASS_FILES=$1

#~/fuzzingandroid/scripts/pull_coverage.sh coverage_temp

if [ -z "$(ls -A $EC_DIR)" ]; then
    echo "so far no ec files are generated."
    exit 0
fi      

EC_FILES=""

for EC in $EC_DIR/*
do 
        EC_FILES=$EC_FILES" $EC "
done

echo $EC_FILES

var=`date +"%T"`
java -jar $JACOCO_DIR/jacococli.jar report $EC_FILES $CLASS_FILES --xml $OUTPUT/coverage.xml
cp $OUTPUT/coverage.xml $OUTPUT/coverage_$var.xml
