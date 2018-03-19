#!/bin/bash

set -e

main() {
	echo "Deploying application"
	local keys=$(shipctl get_integration_resource_keys app_deploy_key)
	echo $keys

}


main
