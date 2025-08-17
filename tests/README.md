# Testing Documentation

This directory contains comprehensive unit tests for all media conversion scripts.

## Test Structure

```
tests/
├── run_tests.sh                    # Main test runner
├── test_framework.sh              # Test framework and utilities
├── test_convertImageToWebp.sh     # Image conversion script tests
├── test_convertVideoToWebm.sh     # Video conversion script tests
└── test_addPrefixToFilename.sh    # Filename prefix script tests
```

## Running Tests

### Run All Tests
```bash
# From project root
./tests/run_tests.sh

# From tests directory
cd tests && ./run_tests.sh
```

### Run Individual Test Suites
```bash
# Run specific test file
./tests/test_convertImageToWebp.sh

# Or source the framework and run manually
source tests/test_framework.sh
source tests/test_convertImageToWebp.sh
```

## Test Categories

### 1. Script Validation Tests
- ✅ Script file existence
- ✅ Script executable permissions
- ✅ Usage message display
- ✅ Error handling for invalid inputs

### 2. Input Validation Tests
- ✅ File extension recognition
- ✅ Directory vs file handling
- ✅ Unsupported file rejection
- ✅ Path validation

### 3. Logic Tests
- ✅ Command line argument parsing
- ✅ Output directory creation logic
- ✅ File processing logic
- ✅ Error exit codes

### 4. Integration Tests
- ✅ All scripts present and executable
- ✅ Documentation completeness
- ✅ Dependency availability checks

## Test Framework Features

### Assertion Functions
- `assert_equals` - Compare expected vs actual values
- `assert_file_exists` - Verify file existence
- `assert_dir_exists` - Verify directory existence  
- `assert_exit_code` - Verify command exit codes

### Utilities
- `setup_test_env` - Create isolated test environment
- `cleanup_test_env` - Clean up test files
- `print_color` - Colored console output
- Automatic test counting and reporting

## Example Test Output

```
==========================================
  Media Conversion Scripts - Test Suite  
==========================================

Project Directory: /path/to/convert-to-webp
Test Directory: /path/to/convert-to-webp/tests

=== Checking Dependencies ===
✓ cwebp found: /opt/homebrew/bin/cwebp
✓ ffmpeg found: /opt/homebrew/bin/ffmpeg

=== Running Test Suite: Image Conversion Tests ===
✓ PASS: convertImageToWebp.sh exists
✓ PASS: convertImageToWebp.sh is executable
✓ PASS: Script exits with code 1 when no arguments provided
✓ PASS: Script shows usage message when no arguments provided
...

==========================================
           FINAL TEST REPORT             
==========================================

Test Suites Summary:
Total Suites: 4
Passed Suites: 4
Failed Suites: 0

Individual Tests Summary:
Total Tests: 32
Passed Tests: 32
Failed Tests: 0
Success Rate: 100%

🎉 ALL TESTS PASSED! 🎉
```

## Test Coverage

### convertImageToWebp.sh
- Script existence and permissions
- Usage message and error handling
- File/directory input validation
- Supported file extension logic
- WebP output directory logic

### convertVideoToWebm.sh  
- Script existence and permissions
- Usage message and error handling
- File/directory input validation
- Supported video format logic
- WebM exclusion logic
- FFmpeg dependency check

### addPrefixToFilename.sh
- Script existence and permissions
- Usage message and parameter validation
- Single file renaming
- Directory batch renaming
- File count reporting
- Special character handling

## Notes

- Tests use mock files (text files with appropriate extensions) to avoid dependency on actual media files
- Tests focus on script logic rather than actual conversion quality
- Dependency checks provide warnings but don't fail tests if tools are missing
- All tests use isolated temporary directories to avoid conflicts
- Tests are designed to be safe and non-destructive

## Continuous Integration

These tests can be integrated into CI/CD pipelines:

```bash
# Exit code 0 = all tests passed
# Exit code 1 = some tests failed
./tests/run_tests.sh && echo "CI: Tests passed" || echo "CI: Tests failed"
```
