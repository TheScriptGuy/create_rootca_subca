#!/bin/bash

DATE=`which date`

CURRENTDATE=`$DATE +"%Y-%m-%d - %H:%M:%S"`

git add .
git commit -m "$CURRENTDATE - Updating all files. "
git push -u origin main
