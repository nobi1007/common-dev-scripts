#!/bin/bash

set -e

GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

input="$1"

if [ -z "$input" ]; then
  echo "Usage: $0 /path/to/file/or/folder"
  exit 1
fi

# Function to humanize bytes
humanize() {
  b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,P,E,Z,Y}B)
  while ((b > 1024 && s < ${#S[@]}-1)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    ((s++))
  done
  echo "$b$d ${S[$s]}"
}

# Find all png files recursively if dir, or single file if file
if [ -d "$input" ]; then
  basedir="$(cd "$input" && pwd)"
  files=$(find "$input" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" \) ! -iname "*.svg")
  outdir="$basedir/webp"
elif [ -f "$input" ] && [[ "$input" =~ \.(png|jpg|jpeg|gif|bmp|tiff)$ ]] && [[ "$input" != *.svg ]]; then
  basedir="$(cd "$(dirname "$input")" && pwd)"
  files="$input"
  outdir="$basedir/webp"
else
  echo "Provide an image file (png, jpg, jpeg, gif, bmp, tiff) or directory containing such files. SVG files are not supported."
  exit 1
fi

mkdir -p "$outdir"

echo "Starting image to WebP conversion..."
printf "\n%-50s %-15s %-15s %-12s\n" "File" "Old Size" "New Size" "Diff"
printf '%0.s-' {1..100}; echo

total_old=0
total_new=0
count=0

for file in $files; do
  # Path relative to basedir
  rel="${file#$basedir/}"

  # Get extension (lowercase, portable)
  ext="$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')"
  # Output file path under webp folder, maintaining structure
  outpath="$outdir/${rel%.*}.webp"
  mkdir -p "$(dirname "$outpath")"

  # Convert using cwebp for supported formats
  cwebp -quiet "$file" -o "$outpath"

  old_size=$(stat -f %z "$file")
  new_size=$(stat -f %z "$outpath")
  total_old=$((total_old + old_size))
  total_new=$((total_new + new_size))
  diff=$(( old_size - new_size ))
  ((count++))
  if [ "$diff" -ge 0 ]; then
    size_str="${GREEN}↓ $(humanize $diff)${NC}"
  else
    size_str="${RED}↑ $(humanize $(( -diff )))${NC}"
  fi
  printf "%-50s %-15s %-15s %-12b\n" "$rel" "$(humanize $old_size)" "$(humanize $new_size)" "$size_str"
  echo "Converted: $rel -> ${rel%.*}.webp"
done

printf '%0.s-' {1..100}; echo
saved=$((total_old - total_new))
if [ "$saved" -ge 0 ]; then
  saved_str="${GREEN}$(humanize $saved)${NC}"
else
  saved_str="${RED}$(humanize $(( -saved )))${NC}"
fi
echo "Image to WebP conversion complete."
echo -e "${CYAN}Total images:${NC} $count"
echo -e "${CYAN}Initial size:${NC} $(humanize $total_old)"
echo -e "${CYAN}Converted size:${NC} $(humanize $total_new)"
echo -e "${CYAN}Saved:${NC} $saved_str"
