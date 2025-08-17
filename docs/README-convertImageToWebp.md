# convertImageToWebp.sh

Converts images (PNG, JPG, JPEG, GIF, BMP, TIFF) to WebP format for better web optimization.

## Prerequisites

-   **cwebp** - Install via Homebrew:
    ```bash
    brew install webp
    ```

## Usage

```bash
# Make script executable
chmod +x convertImageToWebp.sh

# Convert a single image
./convertImageToWebp.sh /path/to/image.png

# Convert all images in a directory
./convertImageToWebp.sh /path/to/directory
```

## Supported Formats

**Input:** PNG, JPG, JPEG, GIF, BMP, TIFF  
**Output:** WebP format  
**Excluded:** SVG files (not supported by WebP)

## Features

-   **Recursive directory processing** - Processes images in subdirectories
-   **Structure preservation** - Maintains original folder structure in output
-   **Size comparison** - Shows original vs converted file sizes
-   **Progress tracking** - Displays conversion status for each file
-   **Color-coded output** - Green for size reduction, red for size increase
-   **Error handling** - Stops on errors and validates input files

## Output

Creates a `webp` folder in the same directory as the input, containing all converted images:

```
your-folder/
├── original-images/
│   ├── photo1.jpg
│   └── subfolder/
│       └── photo2.png
└── webp/               # Created by script
    ├── photo1.webp
    └── subfolder/
        └── photo2.webp
```

## Example Output

```
Starting image to WebP conversion...

File                                              Old Size        New Size        Diff
----------------------------------------------------------------------------------------------------
photo1.jpg                                        2.5 MB          1.8 MB          ↓ 700 KB
screenshot.png                                    850 KB          320 KB          ↓ 530 KB
Converted: photo1.jpg -> photo1.webp
Converted: screenshot.png -> screenshot.webp
----------------------------------------------------------------------------------------------------
Image to WebP conversion complete.
Total images: 2
Initial size: 3.35 MB
Converted size: 2.12 MB
Saved: 1.23 MB
```

## Technical Details

-   Uses `cwebp` for conversion with quiet mode for clean output
-   Preserves original files (only creates converted copies)
-   Uses portable shell scripting compatible with macOS
-   Handles file paths with spaces and special characters
-   Provides human-readable file size formatting

## Troubleshooting

-   Ensure cwebp is installed: `which cwebp`
-   Check script permissions: `chmod +x convertImageToWebp.sh`
-   For large images, conversion may take time
-   Script exits on first error due to `set -e`
