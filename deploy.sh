#!/bin/bash

set -e

readonly PRIVATE_KEY_LOCATION=/tmp/privateKey

_extract_key() {
  echo "Extracting AWS PEM"
  echo "-----------------------------------"
	local pem_key_path=$(shipctl get_resource_meta app_deploy_key)
	pushd $pem_key_path
  if [ ! -f "integration.json" ]; then
    echo "No credentials file found at location: $pem_key_path"
    return 1
  fi

  cat integration.json | jq -r '.key' > key.pem
  chmod 600 key.pem

  echo "Completed Extracting AWS PEM"
  echo "-----------------------------------"

  ssh-add key.pem
  echo "SSH key added successfully"
  echo "--------------------------------------"

	echo "Listing all added key-pairs"
	ssh-add -L
  echo "--------------------------------------"
  popd
}

_extract_private_key() {
	echo "Extracting private key"
	local privateKey=$(shipctl get_integration_resource_field app_deploy_key key)
	#local privateKey=$(shipctl get_integration_resource_keys app_deploy_key)

	echo "Writing private key to file"
	echo $privateKey > $PRIVATE_KEY_LOCATION

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
	#_extract_private_key
	_extract_key
}

main
