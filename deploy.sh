#!/bin/bash

set -e

readonly PRIVATE_KEY_LOCATION=/tmp/privateKey
readonly APP_CONTAINER_NAME="blog"

export DEPLOYMENT_IP=""
export DEPLOYMENT_USERNAME=""
export APP_IMAGE=""

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

	local endpoint_int_path=$(shipctl get_resource_meta app_deployment_endpoint)
	pushd $endpoint_int_path

	DEPLOYMENT_USERNAME=$(cat integration.json | jq -r '.username')
	echo "Username: $DEPLOYMENT_USERNAME"
  echo "-----------------------------------"

	DEPLOYMENT_IP=$(cat integration.json | jq -r '.ip')
	echo "IP: $DEPLOYMENT_IP"
  echo "-----------------------------------"

	popd
}

_extract_image() {
	echo "Extracting image to be deployed"
  echo "-----------------------------------"

	APP_IMAGE=$(shipctl get_resource_version_name "app_image")
	echo "APP_IMAGE: $APP_IMAGE"
  echo "-----------------------------------"
}

_update_app() {
	echo "Updating app"
  echo "-----------------------------------"

	echo "Pulling latest image"
	local pull_cmd="sudo docker pull $APP_IMAGE"
	ssh $DEPLOYMENT_USERNAME@$DEPLOYMENT_IP "$pull_cmd"

	echo "Removing old container"
	local remove_cmd="sudo docker rm -f $APP_CONTAINER_NAME"
	ssh $DEPLOYMENT_USERNAME@$DEPLOYMENT_IP "$remove_cmd"

	echo "Running new container"
	local run_cmd="sudo docker run --name=$APP_CONTAINER_NAME $APP_IMAGE"
	ssh $DEPLOYMENT_USERNAME@$DEPLOYMENT_IP "$run_cmd"
}

main() {
	echo "Deploying application"
  eval $(ssh-agent -s)
	_extract_key
	_extract_deployment_endpoint
	_extract_image
	_update_app
}

main
