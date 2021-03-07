# create_rootca_subca

I do a lot of testing with Root and Subordinate CA's and got tired of generating new CA's every time I wanted to test a new ciphersuite or RSA key size.

These scripts will help create Root and Subordinate CA's (some information can be configured with variables).

* go_ec.sh will generate elliptic curve Root and Subordinate CA's (defaults to secp224r1, secp384r1, secp521r1)
* go_rsa.sh will generate RSA (defaults to 2048, 4096 and 8192 bit)

Fields that can be edited (currently defaults to):
``
ORGANIZATIONNAME="Acme Widgets Ltd."
ORGANIZATIONALUNITNAME="Notorious Big Infosec Group (BIG)"
``

How many days do you want the CA's to be valid for? Keeping in mind that Subordinate CA days can't be larger than Root CA Days.

10 years + 2 days
``
DEFAULT_ROOTCA_DAYS=3652
``

2 years + 2 days
``
DEFAULT_SUBCA_DAYS=732
``

Which hash do you want to use for signing the certificates.
Keep in mind that SHA-1 certificates are not trusted by many vendors any more.
``
DEFAULT_MD="sha256"
``

For the Elliptic Curve keys, edit EC_KEYS appropriately.
``
EC_KEYS="secp224r1 secp384r1 secp521r1"
``

For a list of elliptic curves supported by openssl run the following command:
``
openssl ecparam -list_curves
``




