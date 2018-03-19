#!/bin/bash

set -e

readonly PRIVATE_KEY_LOCATION=/tmp/privateKey

_extract_private_key() {
	echo "Extracting private key"
	local privateKey=$(shipctl get_integration_resource_field app_deploy_key key)
	#local privateKey=$(shipctl get_integration_resource_keys app_deploy_key)

	echo "Writing private key to file"
	echo -e $privateKey > $PRIVATE_KEY_LOCATION

	cat $PRIVATE_KEY_LOCATION

	echo "Updating key file permissions"
	chmod -c 600 $PRIVATE_KEY_LOCATION

	echo "adding private key to ssh-keychain"
	ssh-add $PRIVATE_KEY_LOCATION

	echo "listing all added key-pairs"
	ssh-add -L
}


main() {
	echo "Deploying application"
  eval $(ssh-agent -s)
	_extract_private_key
}

main
