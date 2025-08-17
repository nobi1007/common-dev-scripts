#!/bin/bash

# Unit tests for addPrefixToFilename.sh

# Test setup
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_SCRIPT="$PROJECT_DIR/addPrefixToFilename.sh"
TEST_DIR="/tmp/test_prefix_$$"

test_prefix_script_exists() {
    assert_file_exists "$TEST_SCRIPT" "addPrefixToFilename.sh exists"
}

test_prefix_script_executable() {
    if [ -x "$TEST_SCRIPT" ]; then
        assert_equals "0" "0" "addPrefixToFilename.sh is executable"
    else
        assert_equals "0" "1" "addPrefixToFilename.sh is executable"
    fi
}

test_prefix_script_usage_message() {
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

test_prefix_script_missing_prefix() {
    local output
    output=$("$TEST_SCRIPT" "" "/some/path" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 when prefix is missing"
}

test_prefix_script_missing_path() {
    local output
    output=$("$TEST_SCRIPT" "prefix_" "" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 when path is missing"
}

test_prefix_script_invalid_path() {
    local output
    output=$("$TEST_SCRIPT" "prefix_" "/nonexistent/path" 2>&1)
    local exit_code=$?
    
    assert_exit_code "1" "$exit_code" "Script exits with code 1 for nonexistent path"
}

test_prefix_single_file() {
    setup_test_env "$TEST_DIR"
    
    # Create a test file
    echo "test content" > "$TEST_DIR/testfile.txt"
    
    # Run the script
    local output
    output=$("$TEST_SCRIPT" "prefix_" "$TEST_DIR/testfile.txt" 2>&1)
    local exit_code=$?
    
    assert_exit_code "0" "$exit_code" "Script succeeds when renaming single file"
    
    # Check if file was renamed
    assert_file_exists "$TEST_DIR/prefix_testfile.txt" "File was renamed with prefix"
    
    # Check if original file no longer exists
    if [ ! -f "$TEST_DIR/testfile.txt" ]; then
        assert_equals "1" "1" "Original file was removed after renaming"
    else
        assert_equals "1" "0" "Original file was removed after renaming"
    fi
    
    cleanup_test_env "$TEST_DIR"
}

test_prefix_directory() {
    setup_test_env "$TEST_DIR"
    
    # Create test files
    echo "content1" > "$TEST_DIR/file1.txt"
    echo "content2" > "$TEST_DIR/file2.jpg"
    echo "content3" > "$TEST_DIR/file3.png"
    
    # Run the script on directory
    local output
    output=$("$TEST_SCRIPT" "test_" "$TEST_DIR" 2>&1)
    local exit_code=$?
    
    assert_exit_code "0" "$exit_code" "Script succeeds when processing directory"
    
    # Check if files were renamed
    assert_file_exists "$TEST_DIR/test_file1.txt" "First file was renamed with prefix"
    assert_file_exists "$TEST_DIR/test_file2.jpg" "Second file was renamed with prefix"
    assert_file_exists "$TEST_DIR/test_file3.png" "Third file was renamed with prefix"
    
    # Check if original files no longer exist
    if [ ! -f "$TEST_DIR/file1.txt" ] && [ ! -f "$TEST_DIR/file2.jpg" ] && [ ! -f "$TEST_DIR/file3.png" ]; then
        assert_equals "1" "1" "Original files were removed after renaming"
    else
        assert_equals "1" "0" "Original files were removed after renaming"
    fi
    
    cleanup_test_env "$TEST_DIR"
}

test_prefix_file_count() {
    setup_test_env "$TEST_DIR"
    
    # Create test files
    echo "content1" > "$TEST_DIR/file1.txt"
    echo "content2" > "$TEST_DIR/file2.txt"
    
    # Run the script on directory
    local output
    output=$("$TEST_SCRIPT" "count_" "$TEST_DIR" 2>&1)
    
    # Check if output contains count information
    if [[ "$output" == *"2 file(s) renamed"* ]]; then
        assert_equals "1" "1" "Script reports correct file count"
    else
        assert_equals "1" "0" "Script reports correct file count"
    fi
    
    cleanup_test_env "$TEST_DIR"
}

test_prefix_with_spaces() {
    setup_test_env "$TEST_DIR"
    
    # Create a test file with spaces in name
    echo "test content" > "$TEST_DIR/test file.txt"
    
    # Run the script
    local output
    output=$("$TEST_SCRIPT" "prefix_" "$TEST_DIR/test file.txt" 2>&1)
    local exit_code=$?
    
    assert_exit_code "0" "$exit_code" "Script handles files with spaces in names"
    
    # Check if file was renamed
    assert_file_exists "$TEST_DIR/prefix_test file.txt" "File with spaces was renamed correctly"
    
    cleanup_test_env "$TEST_DIR"
}

test_prefix_special_characters() {
    setup_test_env "$TEST_DIR"
    
    # Create a test file
    echo "test content" > "$TEST_DIR/testfile.txt"
    
    # Test with special characters in prefix
    local output
    output=$("$TEST_SCRIPT" "2024-01-01_" "$TEST_DIR/testfile.txt" 2>&1)
    local exit_code=$?
    
    assert_exit_code "0" "$exit_code" "Script handles special characters in prefix"
    
    # Check if file was renamed
    assert_file_exists "$TEST_DIR/2024-01-01_testfile.txt" "File was renamed with special character prefix"
    
    cleanup_test_env "$TEST_DIR"
}

# Run all tests
test_prefix_script_exists
test_prefix_script_executable
test_prefix_script_usage_message
test_prefix_script_missing_prefix
test_prefix_script_missing_path
test_prefix_script_invalid_path
test_prefix_single_file
test_prefix_directory
test_prefix_file_count
test_prefix_with_spaces
test_prefix_special_characters
