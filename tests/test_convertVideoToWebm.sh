#!/bin/bash

# Unit tests for convertVideoToWebm.sh

# Test setup
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_SCRIPT="$PROJECT_DIR/convertVideoToWebm.sh"
TEST_DIR="/tmp/test_video_conversion_$$"

test_video_script_exists() {
    assert_file_exists "$TEST_SCRIPT" "convertVideoToWebm.sh exists"
}

test_video_script_executable() {
    if [ -x "$TEST_SCRIPT" ]; then
        assert_equals "0" "0" "convertVideoToWebm.sh is executable"
    else
        assert_equals "0" "1" "convertVideoToWebm.sh is executable"
    fi
}

test_video_script_usage_message() {
    local output
    output=$("$TEST_SCRIPT" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 when no arguments provided"
    
    if [[ "$output" == *"Usage:"* ]]; then
        assert_equals "1" "1" "Script shows usage message when no arguments provided"
    else
        assert_equals "1" "0" "Script shows usage message when no arguments provided"
    fi
}

test_video_script_invalid_file() {
    local output
    output=$("$TEST_SCRIPT" "/nonexistent/file.mp4" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 for nonexistent file"
}

test_video_script_invalid_directory() {
    local output
    output=$("$TEST_SCRIPT" "/nonexistent/directory" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 for nonexistent directory"
}

test_video_script_unsupported_file() {
    setup_test_env "$TEST_DIR"
    
    # Create a test file with unsupported extension
    echo "test content" > "$TEST_DIR/test.txt"
    
    local output
    output=$("$TEST_SCRIPT" "$TEST_DIR/test.txt" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 for unsupported file type"
    
    cleanup_test_env "$TEST_DIR"
}

test_video_webm_exclusion() {
    setup_test_env "$TEST_DIR"
    
    # Create a WebM file (should be excluded)
    echo "fake webm content" > "$TEST_DIR/test.webm"
    
    local output
    output=$("$TEST_SCRIPT" "$TEST_DIR/test.webm" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script rejects WebM files as expected"
    
    cleanup_test_env "$TEST_DIR"
}

test_video_directory_processing() {
    setup_test_env "$TEST_DIR"
    
    # Create test directory structure
    mkdir -p "$TEST_DIR/subdir"
    
    # Create mock video files (we'll use text files with video extensions for testing)
    echo "fake mp4 content" > "$TEST_DIR/test1.mp4"
    echo "fake mov content" > "$TEST_DIR/test2.mov"
    echo "fake avi content" > "$TEST_DIR/subdir/test3.avi"
    echo "webm content" > "$TEST_DIR/test.webm"  # Should be excluded
    
    # Test directory detection
    local output
    # We expect this to fail because ffmpeg won't work on fake files, but we test the logic
    output=$("$TEST_SCRIPT" "$TEST_DIR" 2>&1 || true)
    
    # Check if webm directory would be created (test the logic)
    if [[ "$output" == *"webm"* ]] || [[ "$output" == *"Starting video"* ]]; then
        assert_equals "1" "1" "Script recognizes directory input and attempts processing"
    else
        assert_equals "1" "0" "Script recognizes directory input and attempts processing"
    fi
    
    cleanup_test_env "$TEST_DIR"
}

test_video_file_extension_logic() {
    setup_test_env "$TEST_DIR"
    
    # Test various supported extensions
    extensions=("mp4" "mov" "avi" "mkv" "flv" "wmv" "mpeg" "mpg" "m4v" "3gp" "ogg")
    
    for ext in "${extensions[@]}"; do
        echo "test content" > "$TEST_DIR/test.$ext"
        
        # Test if script accepts the file (it will fail at ffmpeg stage, but should accept the extension)
        local output
        output=$("$TEST_SCRIPT" "$TEST_DIR/test.$ext" 2>&1 || true)
        
        if [[ "$output" == *"Starting video"* ]] || [[ "$output" == *"webm"* ]]; then
            assert_equals "1" "1" "Script accepts .$ext files"
        else
            # Check if it's rejected for the right reason (not supported format vs other error)
            if [[ "$output" == *"Provide a video file"* ]]; then
                assert_equals "1" "0" "Script accepts .$ext files"
            else
                # Other error (like ffmpeg not found or file format issue) - this is acceptable
                assert_equals "1" "1" "Script accepts .$ext files (failed at processing stage, not validation)"
            fi
        fi
    done
    
    cleanup_test_env "$TEST_DIR"
}

test_video_ffmpeg_dependency() {
    # Check if ffmpeg is available
    if command -v ffmpeg >/dev/null 2>&1; then
        assert_equals "1" "1" "ffmpeg is available in PATH"
    else
        print_color "$YELLOW" "⚠ WARNING: ffmpeg not found in PATH - video conversion will not work"
        assert_equals "1" "0" "ffmpeg is available in PATH (WARNING: not found)"
    fi
}

# Run all tests
test_video_script_exists
test_video_script_executable
test_video_script_usage_message
test_video_script_invalid_file
test_video_script_invalid_directory
test_video_script_unsupported_file
test_video_webm_exclusion
test_video_directory_processing
test_video_file_extension_logic
test_video_ffmpeg_dependency
