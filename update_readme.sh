#!/bin/bash

DATE=`which date`

CURRENTDATE=`$DATE +"%Y-%m-%d - %H:%M:%S"`

git add README.md
git commit -m "$CURRENTDATE - Updating README.md file. "
git push -u origin main
