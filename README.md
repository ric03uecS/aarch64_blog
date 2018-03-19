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
