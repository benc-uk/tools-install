#!/bin/bash

set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start 'deno'
curl -fsSL https://deno.land/x/install/install.sh | sh

end 'deno' '--version'
