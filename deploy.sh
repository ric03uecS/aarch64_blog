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

_extract_deployment_endpoint() {
	echo "Extracting username and ip address of deployment endpoint"
  echo "-----------------------------------"

	local deployment_username=$(shipctl get_integration_resource_field app_deployment_endpoint username)
	echo "Username: $deployment_username"
  echo "-----------------------------------"

	local deployment_ip=$(shipctl get_integration_resource_field app_deployment_endpoint ip)
	echo "IP: $deployment_ip"
  echo "-----------------------------------"

}

main() {
	echo "Deploying application"
  eval $(ssh-agent -s)
	_extract_key
	_extract_deployment_endpoint
}

main
