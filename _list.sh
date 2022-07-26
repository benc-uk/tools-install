#!/bin/bash

# loop through all .sh files
for f in ./[a-z]*.*; do 
  name=$(grep 'NAME=".*"' "$f")

  name=${name:6:-1}
    echo "- **${f:2}** - $name"
done