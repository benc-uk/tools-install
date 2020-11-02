#!/bin/bash

#
# This installs 'pulumi'
#

set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start 'pulumi'
curl -fsSL https://get.pulumi.com | sh

end 'pulumi' 'version'
