#!/bin/bash
set -e
source _lib.sh

start "Porter"

curl https://cdn.deislabs.io/porter/latest/install-linux.sh | bash

end 'porter' '--version'