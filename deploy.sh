#!/bin/bash

set -e

readonly PRIVATE_KEY_LOCATION=/tmp/privateKey
readonly APP_CONTAINER_NAME="blog"
export DEPLOYMENT_IP=""
export DEPLOYMENT_USERNAME=""

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

	local image_name=$(shipctl get_resource_pointer_key "app_image" "sourceName")
	echo $image_name

	local image_version=$(shipctl get_resource_version_number "app_image")
	echo $image_version

}

_update_app() {
	echo "Updating app"
  echo "-----------------------------------"

	local pull_cmd="sudo docker pull ric03uec/aarch64_app:20"
	ssh $DEPLOYMENT_USERNAME@$DEPLOYMENT_IP "$pull_cmd"

	local remove_cmd="sudo docker rm -f $APP_CONTAINER_NAME"
	ssh $DEPLOYMENT_USERNAME@$DEPLOYMENT_IP "$remove_cmd"

	local run_cmd="sudo docker run --name=$APP_CONTAINER_NAME $APP_IMAGE"


}

main() {
	echo "Deploying application"
  eval $(ssh-agent -s)
	_extract_key
	_extract_deployment_endpoint
	_extract_image
}

main
