#!/bin/bash

set -ex

# Clean up old builds that may have failed
rm -rf dcim openDCIM-19.01 openDCIM-19.01.tar.gz

wget https://opendcim.org/packages/openDCIM-19.01.tar.gz

tar xzf openDCIM-19.01.tar.gz
mv openDCIM-19.01 dcim

docker build . -t opendcim/opendcim:19.01-ubuntu -t opendcim/opendcim:19.01 -t opendcim/opendcim:latest --no-cache

# To push to docker hub, you must either already be logged in, or add the following line:
# docker login -u mydockerid -p mydockerpassword

docker push opendcim/opendcim:19.01-ubuntu
docker push opendcim/opendcim:19.01
docker push opendcim/opendcim:latest

rm -rf dcim
rm openDCIM-19.01.tar.gz
