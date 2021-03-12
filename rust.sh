#!/bin/bash

# Install rust and rustup

set -e
start 'rust'
curl https://sh.rustup.rs -sSf | sh

end 'rustc' '--version'