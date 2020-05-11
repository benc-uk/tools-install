#!/bin/bash
set -e
DIR=$(cd `dirname $0` && pwd)
source $DIR/.lib.sh

start "Jekyll"

sudo apt-get install ruby-full build-essential zlib1g-dev
gem install jekyll bundler

end 'jekyll' '--version'