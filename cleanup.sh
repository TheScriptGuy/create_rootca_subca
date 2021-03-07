#!/bin/bash
echo "Removing all certificate authorities, revocation lists, certificates"

rm -rf *ca *certs *crl

if [ $? -eq 0 ]; then
  echo "Successfully deleted."
  exit 0

else 
  exit 1
fi

