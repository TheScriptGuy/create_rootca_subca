#!/bin/bash

# Script name:	            go_ec.sh
# Author:                   github@remotenode.org
# Version:                  0.01
# Date last modified:       2021/03/05
# Description:              Create Elliptic Curve Certificate Root and Subordinate Authority
# 
# Changelog:                2021/03/05 - Initial publish.
#



ORGANIZATIONNAME="Acme Widgets Ltd."
ORGANIZATIONALUNITNAME="Notorious Big Infosec Group (BIG)"

DEFAULT_ROOTCA_DAYS=3652
DEFAULT_SUBCA_DAYS=732
DEFAULT_MD="sha256"

# ROOT CA TEMPLATE
ROOTCA_TEMPLATE="etc/root-ca-ec-template.conf"

# Subordinate CA TEMPLATE
SUBCA_TEMPLATE="etc/signing-ca-ec-template.conf"

EC_KEYS="secp224r1 secp384r1 secp521r1"

# =========================================================


for i in $EC_KEYS
do

  # Root CA's
  # ===========================

  # Root CA Template prep
  ROOTCA_CONF="etc/root-ca-ec-$i.conf"

  cat $ROOTCA_TEMPLATE | sed -e "s/TEMPLATE/$i/g; s/ORGANIZATIONNAME/$ORGANIZATIONNAME/g; s/ORGANIZATIONALUNITNAME/$ORGANIZATIONALUNITNAME/g; s/DEFAULT_ROOTCA_DAYS/$DEFAULT_ROOTCA_DAYS/g; s/DEFAULT_MD/$DEFAULT_MD/g" > $ROOTCA_CONF

  ROOTCA_DIR="root-ca-ec-$i"
	mkdir -p ca/$ROOTCA_DIR/private ca/$ROOTCA_DIR/db $ROOTCA_DIR-crl $ROOTCA_DIR-certs
	chmod 700 ca/$ROOTCA_DIR/private

	cp /dev/null ca/$ROOTCA_DIR/db/$ROOTCA_DIR.db
	cp /dev/null ca/$ROOTCA_DIR/db/$ROOTCA_DIR.db.attr
	echo 01 > ca/$ROOTCA_DIR/db/$ROOTCA_DIR.crt.srl
	echo 01 > ca/$ROOTCA_DIR/db/$ROOTCA_DIR.crl.srl


  openssl ecparam -name $i -genkey -noout -out ca/$ROOTCA_DIR/private/$ROOTCA_DIR.key
	
  openssl req -new -config $ROOTCA_CONF -out ca/root-ca-ec-$i.csr -key ca/$ROOTCA_DIR/private/$ROOTCA_DIR.key
	
  openssl ca -batch -selfsign -config $ROOTCA_CONF -in ca/root-ca-ec-$i.csr -out ca/root-ca-ec-$i.crt -extensions root_ca_ext

  echo "Root CA - $i ...DONE"

  echo

  # Subordinate CA's
  # ===========================

  # Subordinate CA Template prep
  SUBCA_CONF="etc/signing-ca-ec-$i.conf"

  cat $SUBCA_TEMPLATE | sed -e "s/TEMPLATE/$i/g; s/ORGANIZATIONNAME/$ORGANIZATIONNAME/g; s/ORGANIZATIONALUNITNAME/$ORGANIZATIONALUNITNAME/g; s/DEFAULT_MD/$DEFAULT_MD/g" > $SUBCA_CONF

  SIGNINGCA_DIR="signing-ca-ec-$i"

	mkdir -p ca/$SIGNINGCA_DIR/private ca/$SIGNINGCA_DIR/db $SIGNINGCA_DIR-crl $SIGNINGCA_DIR-certs
	chmod 700 ca/$SIGNINGCA_DIR/private

	cp /dev/null ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.db
	cp /dev/null ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.db.attr
	echo 01 > ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.crt.srl
	echo 01 > ca/$SIGNINGCA_DIR/db/$SIGNINGCA_DIR.crl.srl

  echo "Generating Subordinate CA - $i private key"
  openssl ecparam -name $i -genkey -noout -out ca/$SIGNINGCA_DIR/private/$SIGNINGCA_DIR.key

  echo "Generating Subordinate CA - $i signing request"
	openssl req -new -config $SUBCA_CONF -out ca/signing-ca-ec-$i.csr -key ca/$SIGNINGCA_DIR/private/$SIGNINGCA_DIR.key
	
  echo "Generating Subordinate CA - $i certificate"
  openssl ca -batch -config $ROOTCA_CONF -in ca/signing-ca-ec-$i.csr -out ca/signing-ca-ec-$i.crt -extensions signing_ca_ext -days $DEFAULT_SUBCA_DAYS 

  echo "Subordinate CA $i...done"

  echo

done



