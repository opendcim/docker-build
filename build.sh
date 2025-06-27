#!/bin/bash

set -ex

# Clean up old builds that may have failed
rm -rf dcim openDCIM-master openDCIM-master.zip master.zip openDCIM-*.tar.gz


# wget https://opendcim.org/packages/openDCIM-24.01.tar.gz
wget https://github.com/samilliken/openDCIM/archive/master.zip

# tar zxf openDCIM-24.01.tar.gz
unzip master.zip

# mv openDCIM-24.01 dcim
mv openDCIM-master dcim
rm dcim/install.php
cp dcim/container-install.php dcim/install.php

docker build . --no-cache -t opendcim/opendcim:24.01-beta

# To push to docker hub, you must either already be logged in, or add the following line:
# docker login -u mydockerid -p mydockerpassword

docker push opendcim/opendcim:24.01-beta

rm -rf dcim
rm -f openDCIM-*.tar.gz
rm -f master.zip
