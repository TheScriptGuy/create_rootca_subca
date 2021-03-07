#!/bin/bash

# Script name:              cleanup.sh
# Author:                   github@remotenode.org
# Version:                  0.01
# Date last modified:       2021/03/05
# Description:              Remove configurations that were created.
#
# Changelog:                2021/03/05 - Initial publish.
#


echo "Removing all certificate authorities, revocation lists, certificates"

rm -rf *ca *certs *crl

if [ $? -eq 0 ]; then
  echo "Successfully deleted."
  exit 0

else 
  exit 1
fi

