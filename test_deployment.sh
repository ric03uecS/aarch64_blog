#!/bin/bash

set -e

export APP_PORT=3000
export APP_IP=""


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

	APP_IP=$(cat integration.json | jq -r '.ip')
	echo "IP: $APP_IP"
  echo "-----------------------------------"

	popd
}

_test_application() {
  echo "Testing application endpoint"
  local test_url="http://$APP_IP:$APP_PORT/status"
  local response=$(curl -XGET "$test_url")

  local region=$(echo $response | jq -r '.region')
  local run_mode=$(echo $response | jq -r '.runMode')
  local release=$(echo $response | jq -r '.release')

  echo "-----------------------------------"
	echo "Region: $region"
  echo "Run mode: $run_mode"
  echo "Release: $release"
  echo "-----------------------------------"

}

main() {
	echo "Deploying application"
  _install_deps
	_extract_deployment_endpoint
  _test_application
}

main
