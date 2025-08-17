#!/bin/bash

set -e

GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

prefix="$1"
input="$2"

if [ -z "$prefix" ] || [ -z "$input" ]; then
  echo "Usage: $0 \"prefix_\" /path/to/file/or/folder"
  exit 1
fi

count=0

if [ -d "$input" ]; then
  echo "Adding prefix \"$prefix\" to files in directory: $input"
  for file in "$input"/*; do
    if [ -f "$file" ]; then
      basename=$(basename "$file")
      dirname=$(dirname "$file")
      newname="${prefix}${basename}"
      mv "$file" "$dirname/$newname"
      echo "Renamed: $basename → $newname"
      ((count++))
    fi
  done
elif [ -f "$input" ]; then
  echo "Adding prefix \"$prefix\" to file: $input"
  basename=$(basename "$input")
  dirname=$(dirname "$input")
  newname="${prefix}${basename}"
  mv "$input" "$dirname/$newname"
  echo "Renamed: $basename → $newname"
  ((count++))
else
  echo "Error: '$input' is not a valid file or directory"
  exit 1
fi

echo -e "${CYAN}Prefix addition complete. ${count} file(s) renamed.${NC}"
