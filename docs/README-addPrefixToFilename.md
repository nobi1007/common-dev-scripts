# addPrefixToFilename.sh

Adds a custom prefix to all filenames in a directory or a single file.

## Usage

```bash
# Make script executable
chmod +x addPrefixToFilename.sh

# Add prefix to a single file
./addPrefixToFilename.sh "prefix_" /path/to/file.txt

# Add prefix to all files in a directory
./addPrefixToFilename.sh "prefix_" /path/to/directory
```

## Parameters

1. **Prefix** - The text to add at the beginning of each filename
2. **Target** - File or directory path to process

## Features

- **Single file processing** - Rename individual files
- **Directory processing** - Rename all files in a directory
- **Safe operation** - Shows what will be renamed before executing
- **Error handling** - Validates inputs and handles edge cases
- **Flexible prefix** - Use any string as prefix (including special characters)

## Examples

### Single File
```bash
./addPrefixToFilename.sh "backup_" document.pdf
# Result: document.pdf → backup_document.pdf
```

### Directory
```bash
./addPrefixToFilename.sh "2024_" /path/to/photos/
# Result: 
# photo1.jpg → 2024_photo1.jpg
# photo2.png → 2024_photo2.png
```

## Output Example

```
Adding prefix "backup_" to files...
Renaming: document.pdf → backup_document.pdf
Renaming: image.jpg → backup_image.jpg
Renaming: video.mp4 → backup_video.mp4
Prefix addition complete. 3 files renamed.
```

## Technical Details

- Preserves file extensions
- Handles files with spaces in names
- Works with any file type
- Compatible with macOS filesystem
- Uses safe shell scripting practices

## Use Cases

- **Backup organization** - Add dates or backup labels
- **Version control** - Add version prefixes to files
- **Batch organization** - Categorize files with prefixes
- **Project management** - Add project codes to filenames

## Troubleshooting

- Ensure script has execute permissions: `chmod +x addPrefixToFilename.sh`
- Check that target files/directories exist
- Be careful with special characters in prefixes
- Test on a small set first for large directories
