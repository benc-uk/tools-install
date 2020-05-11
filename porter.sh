#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "Porter"

curl https://cdn.deislabs.io/porter/latest/install-linux.sh | bash

end 'porter' '--version'