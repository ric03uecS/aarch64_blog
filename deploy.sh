#!/bin/bash

set -e

main() {
	echo "Deploying application"
	local keys=$(shipctl get_integration_resource_keys app_deploy_key)
	echo $keys

	local public_key=$(shipctl get_integration_resource_field app_deploy_key publicKey)
	echo $public_key
}


main
