# convertVideoToWebm.sh

Converts videos (MP4, MOV, AVI, MKV, etc.) to WebM format for better web optimization and streaming.

## Prerequisites

-   **ffmpeg** - Install via Homebrew:
    ```bash
    brew install ffmpeg
    ```

## Usage

```bash
# Make script executable
chmod +x convertVideoToWebm.sh

# Convert a single video
./convertVideoToWebm.sh /path/to/video.mp4

# Convert all videos in a directory
./convertVideoToWebm.sh /path/to/directory
```

## Supported Formats

**Input:** MP4, MOV, AVI, MKV, FLV, WMV, MPEG, MPG, M4V, 3GP, OGG  
**Output:** WebM format (VP9 video codec + Opus audio codec)  
**Excluded:** WebM files (already in target format)

## Features

-   **Recursive directory processing** - Processes videos in subdirectories
-   **Structure preservation** - Maintains original folder structure in output
-   **Size comparison** - Shows original vs converted file sizes
-   **Progress tracking** - Displays conversion status for each file
-   **Color-coded output** - Green for size reduction, red for size increase
-   **High-quality encoding** - Uses VP9 + Opus for optimal web performance

## Output

Creates a `webm` folder in the same directory as the input, containing all converted videos:

```
your-folder/
├── original-videos/
│   ├── movie1.mp4
│   └── subfolder/
│       └── clip2.mov
└── webm/               # Created by script
    ├── movie1.webm
    └── subfolder/
        └── clip2.webm
```

## Example Output

```
Starting video to WebM conversion...

File                                              Old Size        New Size        Diff
----------------------------------------------------------------------------------------------------
movie1.mp4                                        45.2 MB         32.1 MB         ↓ 13.1 MB
clip2.mov                                         12.8 MB         9.4 MB          ↓ 3.4 MB
Converted: movie1.mp4 -> movie1.webm
Converted: clip2.mov -> clip2.webm
----------------------------------------------------------------------------------------------------
Video to WebM conversion complete.
Total videos: 2
Initial size: 58.0 MB
Converted size: 41.5 MB
Saved: 16.5 MB
```

## Technical Details

-   Uses ffmpeg with VP9 video codec (`libvpx-vp9`) for excellent compression
-   Uses Opus audio codec (`libopus`) for high-quality audio
-   Error-only logging for clean output during conversion
-   Preserves original files (only creates converted copies)
-   Handles file paths with spaces and special characters
-   Provides human-readable file size formatting

## Performance Notes

-   VP9 encoding is CPU-intensive and may take time for large files
-   WebM format provides excellent compression for web delivery
-   Ideal for HTML5 video streaming and modern browsers
-   Significant file size reduction while maintaining quality

## Troubleshooting

-   Ensure ffmpeg is installed: `which ffmpeg`
-   Check script permissions: `chmod +x convertVideoToWebm.sh`
-   For large videos, conversion will take considerable time
-   Script exits on first error due to `set -e`
-   Monitor CPU usage during conversion (VP9 is demanding)
