Demo blog
---

- This demo blog and pipelines are built on and for aarch64 nodejs platform
  with following features
    - Two tier dockerized nodejs application
    - single YML ith CI and pipeline configuration
    - CI with test and code coverage
    - CI and pipeline jobs running on an aarch64 ubuntu 16.04 host on packet.net
    - build and push application image after each successful CI run
    - link the docker image version with CI version
    - deploy the app to aarch64 host on packet.net
    - update the release version on the app during each deployment which can be
      verified by opening the app URL over internet

## Custom setup

To set a similar pipeline, follow the steps mentioned below

1. From Shippable UI, create a node pool called `aarch64_ubuntu1604` with
   following parameters
    - Architecture: `aarch64`
    - OS: ubuntu 16.04
1. Add a node to the node pool created in previous step
1. Setup a subscription integration called `app_registry` which should be of
   type `Docker`. The credentials in this integration should be able to
   push/pull to docker hub
1. Setup a subscription integration called `app_deploy_key` of type `PEM Key`.
   The PEM Key added for this integration should be able to
   perform passwordless ssh into the packet.net host
1. Setup a subscription integration called `app_deployment_endpoint` of type
    `Key-Value Pair`. There should be two keys in this integration
    - `username`: set to `root`
    - `ip` : set to the publicly accessible IP address of the packet.net host
1. Fork this project
1. create a repo on docker hub where the docker image for this app will be
   pushed. Once created, replace value of `sourceName` in line 10 and line 62 of
   `shippable.yml` with the repo name
1. Navigate to the Subscription on Shippable in which the project is forked
    - enable the project for CI for the subscription
    - enable the project for Pipelines for the subscription (master branch)
1. The runCI and runSH jobs should work as expected

