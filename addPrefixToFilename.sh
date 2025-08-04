#!/bin/bash

# Usage: ./add_prefix.sh /path/to/dir prefix_

dir="$1"
prefix="$2"

if [ -z "$dir" ] || [ -z "$prefix" ]; then
  echo "Usage: $0 /path/to/dir prefix_"
  exit 1
fi

if [ ! -d "$dir" ]; then
  echo "Directory does not exist: $dir"
  exit 1
fi

cd "$dir"

for file in *; do
  if [ -f "$file" ]; then
    mv -- "$file" "${prefix}${file}"
    echo "Renamed: $file -> ${prefix}${file}"
  fi
done
