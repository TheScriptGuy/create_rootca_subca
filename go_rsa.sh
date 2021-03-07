#!/bin/bash

# Script name:              go_rsa.sh
# Author:                   github@remotenode.org
# Version:                  0.01
# Date last modified:       2021/03/05
# Description:              Create RSA Certificate Root and Subordinate Authority
# 
# Changelog:                2021/03/05 - Initial publish.
#

ORGANIZATIONNAME="Acme Widgets Ltd."
ORGANIZATIONALUNITNAME="Notorious Big Infosec Group (BIG)"

# ROOT CA TEMPLATE
ROOTCA_TEMPLATE="etc/root-ca-rsa-template.conf"
  
# Subordinate CA TEMPLATE
SUBCA_TEMPLATE="etc/signing-ca-rsa-template.conf"


RSA_KEYS="2048 4096 8192"

# =========================================================

for i in $RSA_KEYS
do
	# Root CA's
  # ===========================

  # Root CA Template prep
  ROOTCA_CONF="etc/root-ca-rsa-$i.conf"

  cat $ROOTCA_TEMPLATE | sed -e "s/TEMPLATE/$i/g; s/ORGANIZATIONNAME/$ORGANIZATIONNAME/g; s/ORGANIZATIONALUNITNAME/$ORGANIZATIONALUNITNAME/g; s/RSABITS/$i/g" > $ROOTCA_CONF
    
  ROOTCA_DIR="root-ca-rsa-$i"
	mkdir -p ca/$ROOTCA_DIR/private ca/$ROOTCA_DIR/db $ROOTCA_DIR-crl $ROOTCA_DIR-certs
	chmod 700 ca/$ROOTCA_DIR/private

	cp /dev/null ca/$ROOTCA_DIR/db/$ROOTCA_DIR.db
	cp /dev/null ca/$ROOTCA_DIR/db/$ROOTCA_DIR.db.attr
	echo 01 > ca/$ROOTCA_DIR/db/$ROOTCA_DIR.crt.srl
	echo 01 > ca/$ROOTCA_DIR/db/$ROOTCA_DIR.crl.srl

	openssl req -new -nodes -config $ROOTCA_CONF -out ca/root-ca-rsa-$i.csr -keyout ca/$ROOTCA_DIR/private/$ROOTCA_DIR.key

	openssl ca -batch -selfsign -config $ROOTCA_CONF -in ca/root-ca-rsa-$i.csr -out ca/root-ca-rsa-$i.crt -extensions root_ca_ext


  # Subordinate CA's
  # ===========================

  # Subordinate CA Template prep
  SUBCA_CONF="etc/signing-ca-rsa-$i.conf"

  cat $SUBCA_TEMPLATE | sed -e "s/TEMPLATE/$i/g; s/ORGANIZATIONNAME/$ORGANIZATIONNAME/g; s/ORGANIZATIONALUNITNAME/$ORGANIZATIONALUNITNAME/g; s/RSABITS/$i/g" > $SUBCA_CONF

	SIGNINGCA_DIR="signing-ca-rsa-$i"

	mkdir -p ca/$SIGNINGCA_DIR/private ca/$SIGNINGCA_DIR/db $SIGNINGCA_DIR-crl $SIGNINGCA_DIR-certs
	chmod 700 ca/$SIGNINGCA_DIR/private

	cp /dev/null ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.db
	cp /dev/null ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.db.attr
	echo 01 > ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.crt.srl
	echo 01 > ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.crl.srl

	openssl req -new -nodes -config $SUBCA_CONF -out ca/signing-ca-rsa-$i.csr -keyout ca/$SIGNINGCA_DIR/private/$SIGNINGCA_DIR.key
	openssl ca -batch -config $ROOTCA_CONF -in ca/signing-ca-rsa-$i.csr -out ca/signing-ca-rsa-$i.crt -extensions signing_ca_ext
done


