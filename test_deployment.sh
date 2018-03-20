#!/bin/bash

set -e

_install_deps() {
  echo "Installing dependencies"
  echo "-----------------------------------"

  sudo apt-get install -y jq || true

}

_extract_deployment_endpoint() {
	echo "Extracting username and ip address of deployment endpoint"
  echo "-----------------------------------"

	local endpoint_int_path=$(shipctl get_resource_meta app_deployment_endpoint)
	pushd $endpoint_int_path

	DEPLOYMENT_IP=$(cat integration.json | jq -r '.ip')
	echo "IP: $DEPLOYMENT_IP"
  echo "-----------------------------------"

	popd
}

_test_application() {

}

main() {
	echo "Deploying application"
  _install_deps
	_extract_deployment_endpoint
  _test_application
}

main
