#!/bin/bash
set -e
source _lib.sh

start 'dapr'

wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

end 'dapr' '--version'