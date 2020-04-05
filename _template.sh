#!/bin/bash
set -e
source _lib.sh

start 'foo'
sudo apt update

end 'foo' '--version'
