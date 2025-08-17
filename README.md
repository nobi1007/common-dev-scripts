# Media Conversion Scripts

A collection of shell scripts for optimizing images and videos by converting them to modern web formats. These scripts are designed and tested for macOS.

![Tests Passing](https://img.shields.io/badge/tests-65%2F65%20passing-brightgreen?style=flat-square)
![Test Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen?style=flat-square)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)

## Available Scripts

| Script                   | Purpose                       | Documentation                                                  |
| ------------------------ | ----------------------------- | -------------------------------------------------------------- |
| `convertImageToWebp.sh`  | Convert images to WebP format | [📖 Image Conversion Guide](docs/README-convertImageToWebp.md) |
| `convertVideoToWebm.sh`  | Convert videos to WebM format | [📖 Video Conversion Guide](docs/README-convertVideoToWebm.md) |
| `addPrefixToFilename.sh` | Add prefix to filenames       | [📖 Filename Prefix Guide](docs/README-addPrefixToFilename.md) |

## Documentation

For detailed usage instructions, examples, and troubleshooting, see the individual documentation files in the [docs](docs/) folder.

## Testing

This project includes comprehensive unit tests for all scripts:

```bash
# Run all tests
./tests/run_tests.sh

# View test documentation
cat tests/README.md
```

For detailed testing information, see [Testing Documentation](tests/README.md).

## ✅ Test Status

All scripts are thoroughly tested with **65 comprehensive unit tests** covering:

- **Script Validation**: File existence, permissions, usage messages
- **Input Validation**: File formats, directory handling, error cases  
- **Logic Testing**: Parameter parsing, output generation, edge cases
- **Integration Testing**: Cross-script compatibility, documentation completeness

### Latest Test Results
```
==========================================
           FINAL TEST REPORT             
==========================================

Test Suites Summary:
Total Suites: 3
Passed Suites: 3  ✓
Failed Suites: 0

Individual Tests Summary:
Total Tests: 65
Passed Tests: 65  ✓
Failed Tests: 0
Success Rate: 100% 🎉

🎉 ALL TESTS PASSED! 🎉
The media conversion scripts are working correctly.
```

<details>
<summary>📊 View Full Test Report</summary>

```
==========================================
  Media Conversion Scripts - Test Suite  
==========================================

=== Checking Dependencies ===
✓ cwebp found: /opt/homebrew/bin/cwebp
✓ ffmpeg found: /opt/homebrew/bin/ffmpeg

=== Running Test Suite: Image Conversion Tests ===
✓ PASS: convertImageToWebp.sh exists
✓ PASS: convertImageToWebp.sh is executable
✓ PASS: Script exits with code 1 when no arguments provided
✓ PASS: Script shows usage message when no arguments provided
✓ PASS: Script exits with code 1 for nonexistent file
✓ PASS: Script exits with code 1 for nonexistent directory
✓ PASS: Script exits with code 1 for unsupported file type
✓ PASS: Script recognizes directory input and attempts processing
✓ PASS: Script accepts .png files
✓ PASS: Script accepts .jpg files
✓ PASS: Script accepts .jpeg files
✓ PASS: Script accepts .gif files
✓ PASS: Script accepts .bmp files
✓ PASS: Script accepts .tiff files
Suite Results: 14/14 passed
✓ Image Conversion Tests: ALL TESTS PASSED

=== Running Test Suite: Video Conversion Tests ===
✓ PASS: convertVideoToWebm.sh exists
✓ PASS: convertVideoToWebm.sh is executable
✓ PASS: Script exits with code 1 when no arguments provided
✓ PASS: Script shows usage message when no arguments provided
✓ PASS: Script exits with code 1 for nonexistent file
✓ PASS: Script exits with code 1 for nonexistent directory
✓ PASS: Script exits with code 1 for unsupported file type
✓ PASS: Script rejects WebM files as expected
✓ PASS: Script recognizes directory input and attempts processing
✓ PASS: Script accepts .mp4 files
✓ PASS: Script accepts .mov files
✓ PASS: Script accepts .avi files
✓ PASS: Script accepts .mkv files
✓ PASS: Script accepts .flv files
✓ PASS: Script accepts .wmv files
✓ PASS: Script accepts .mpeg files
✓ PASS: Script accepts .mpg files
✓ PASS: Script accepts .m4v files
✓ PASS: Script accepts .3gp files
✓ PASS: Script accepts .ogg files
✓ PASS: ffmpeg is available in PATH
Suite Results: 21/21 passed
✓ Video Conversion Tests: ALL TESTS PASSED

=== Running Test Suite: Filename Prefix Tests ===
✓ PASS: addPrefixToFilename.sh exists
✓ PASS: addPrefixToFilename.sh is executable
✓ PASS: Script exits with code 1 when no arguments provided
✓ PASS: Script shows usage message when no arguments provided
✓ PASS: Script exits with code 1 when prefix is missing
✓ PASS: Script exits with code 1 when path is missing
✓ PASS: Script exits with code 1 for nonexistent path
✓ PASS: Script succeeds when renaming single file
✓ PASS: File was renamed with prefix
✓ PASS: Original file was removed after renaming
✓ PASS: Script succeeds when processing directory
✓ PASS: First file was renamed with prefix
✓ PASS: Second file was renamed with prefix
✓ PASS: Third file was renamed with prefix
✓ PASS: Original files were removed after renaming
✓ PASS: Script reports correct file count
✓ PASS: Script handles files with spaces in names
✓ PASS: File with spaces was renamed correctly
✓ PASS: Script handles special characters in prefix
✓ PASS: File was renamed with special character prefix
Suite Results: 20/20 passed
✓ Filename Prefix Tests: ALL TESTS PASSED

=== Running Integration Tests ===
✓ PASS: Script exists: convertImageToWebp.sh
✓ PASS: Script is executable: convertImageToWebp.sh
✓ PASS: Script exists: convertVideoToWebm.sh
✓ PASS: Script is executable: convertVideoToWebm.sh
✓ PASS: Script exists: addPrefixToFilename.sh
✓ PASS: Script is executable: addPrefixToFilename.sh
✓ PASS: Documentation exists: README.md
✓ PASS: Documentation exists: docs/README-convertImageToWebp.md
✓ PASS: Documentation exists: docs/README-convertVideoToWebm.md
✓ PASS: Documentation exists: docs/README-addPrefixToFilename.md
```

</details>

**Run tests yourself**: `./tests/run_tests.sh`

## Project Structure

```
convert-to-webp/
├── README.md                           # Main documentation
├── convertImageToWebp.sh              # Image to WebP converter
├── convertVideoToWebm.sh              # Video to WebM converter
├── addPrefixToFilename.sh             # File prefix utility
├── docs/                              # Detailed documentation
│   ├── README-convertImageToWebp.md   # Image conversion guide
│   ├── README-convertVideoToWebm.md   # Video conversion guide
│   └── README-addPrefixToFilename.md  # Filename prefix guide
└── tests/                             # Comprehensive test suite
    ├── README.md                      # Testing documentation
    ├── run_tests.sh                   # Main test runner
    ├── test_framework.sh              # Test framework
    ├── test_convertImageToWebp.sh     # Image conversion tests
    ├── test_convertVideoToWebm.sh     # Video conversion tests
    └── test_addPrefixToFilename.sh    # Filename prefix tests
```

## Compatibility

-   **Platform:** macOS (tested)
-   **Shell:** Bash/Zsh compatible
-   **Dependencies:** Homebrew packages (webp, ffmpeg)
