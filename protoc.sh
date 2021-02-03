#!/bin/bash

set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start 'protoc'
sudo apt update
sudo apt install -y protobuf-compiler

end 'protoc' '--version'
