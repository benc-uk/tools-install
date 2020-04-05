#!/bin/bash
set -e
source _lib.sh

start "Jekyll"

sudo apt-get install ruby-full build-essential zlib1g-dev
gem install jekyll bundler

end 'jekyll' '--version'