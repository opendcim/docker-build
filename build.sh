#!/bin/bash

set -ex

# Clean up old builds that may have failed
rm -rf dcim openDCIM-master openDCIM-master.zip master.zip

wget https://github.com/samilliken/openDCIM/archive/20.01.tar.gz

tar zxf 20.01.tar.gz
mv openDCIM-20.01 dcim

docker build . -t opendcim/opendcim:20.01 --no-cache

# To push to docker hub, you must either already be logged in, or add the following line:
# docker login -u mydockerid -p mydockerpassword

docker push opendcim/opendcim:20.01

rm -rf dcim
rm 20.01.tar.gz
