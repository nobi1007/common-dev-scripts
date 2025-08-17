#!/bin/bash

# Unit tests for convertImageToWebp.sh

# Test setup
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_SCRIPT="$PROJECT_DIR/convertImageToWebp.sh"
TEST_DIR="/tmp/test_image_conversion_$$"

test_image_script_exists() {
    assert_file_exists "$TEST_SCRIPT" "convertImageToWebp.sh exists"
}

test_image_script_executable() {
    if [ -x "$TEST_SCRIPT" ]; then
        assert_equals "0" "0" "convertImageToWebp.sh is executable"
    else
        assert_equals "0" "1" "convertImageToWebp.sh is executable"
    fi
}

test_image_script_usage_message() {
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

test_image_script_invalid_file() {
    local output
    output=$("$TEST_SCRIPT" "/nonexistent/file.png" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 for nonexistent file"
}

test_image_script_invalid_directory() {
    local output
    output=$("$TEST_SCRIPT" "/nonexistent/directory" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 for nonexistent directory"
}

test_image_script_unsupported_file() {
    setup_test_env "$TEST_DIR"
    
    # Create a test file with unsupported extension
    echo "test content" > "$TEST_DIR/test.txt"
    
    local output
    output=$("$TEST_SCRIPT" "$TEST_DIR/test.txt" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 for unsupported file type"
    
    cleanup_test_env "$TEST_DIR"
}

test_image_directory_processing() {
    setup_test_env "$TEST_DIR"
    
    # Create test directory structure
    mkdir -p "$TEST_DIR/subdir"
    
    # Create mock image files (we'll use text files with image extensions for testing)
    echo "fake png content" > "$TEST_DIR/test1.png"
    echo "fake jpg content" > "$TEST_DIR/test2.jpg"
    echo "fake gif content" > "$TEST_DIR/subdir/test3.gif"
    echo "svg content" > "$TEST_DIR/test.svg"  # Should be excluded
    
    # Test directory detection
    local output
    # We expect this to fail because cwebp won't work on fake files, but we test the logic
    output=$("$TEST_SCRIPT" "$TEST_DIR" 2>&1 || true)
    
    # Check if webp directory would be created (test the logic)
    if [[ "$output" == *"webp"* ]] || [[ "$output" == *"Starting image"* ]]; then
        assert_equals "1" "1" "Script recognizes directory input and attempts processing"
    else
        assert_equals "1" "0" "Script recognizes directory input and attempts processing"
    fi
    
    cleanup_test_env "$TEST_DIR"
}

test_image_file_extension_logic() {
    setup_test_env "$TEST_DIR"
    
    # Test various supported extensions
    extensions=("png" "jpg" "jpeg" "gif" "bmp" "tiff")
    
    for ext in "${extensions[@]}"; do
        echo "test content" > "$TEST_DIR/test.$ext"
        
        # Test if script accepts the file (it will fail at cwebp stage, but should accept the extension)
        local output
        output=$("$TEST_SCRIPT" "$TEST_DIR/test.$ext" 2>&1 || true)
        
        if [[ "$output" == *"Starting image"* ]] || [[ "$output" == *"webp"* ]]; then
            assert_equals "1" "1" "Script accepts .$ext files"
        else
            # Check if it's rejected for the right reason (not supported format vs other error)
            if [[ "$output" == *"Provide an image file"* ]]; then
                assert_equals "1" "0" "Script accepts .$ext files"
            else
                # Other error (like cwebp not found or file format issue) - this is acceptable
                assert_equals "1" "1" "Script accepts .$ext files (failed at processing stage, not validation)"
            fi
        fi
    done
    
    cleanup_test_env "$TEST_DIR"
}

# Run all tests
test_image_script_exists
test_image_script_executable
test_image_script_usage_message
test_image_script_invalid_file
test_image_script_invalid_directory
test_image_script_unsupported_file
test_image_directory_processing
test_image_file_extension_logic
