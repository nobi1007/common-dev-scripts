#!/bin/bash

# Test framework for shell scripts
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test results array
declare -a TEST_RESULTS

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to assert equality
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ "$expected" = "$actual" ]; then
        print_color "$GREEN" "✓ PASS: $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        TEST_RESULTS+=("PASS: $test_name")
        return 0
    else
        print_color "$RED" "✗ FAIL: $test_name"
        print_color "$RED" "  Expected: '$expected'"
        print_color "$RED" "  Actual:   '$actual'"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        TEST_RESULTS+=("FAIL: $test_name")
        return 1
    fi
}

# Function to assert file exists
assert_file_exists() {
    local file_path="$1"
    local test_name="$2"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ -f "$file_path" ]; then
        print_color "$GREEN" "✓ PASS: $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        TEST_RESULTS+=("PASS: $test_name")
        return 0
    else
        print_color "$RED" "✗ FAIL: $test_name"
        print_color "$RED" "  File not found: $file_path"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        TEST_RESULTS+=("FAIL: $test_name")
        return 1
    fi
}

# Function to assert directory exists
assert_dir_exists() {
    local dir_path="$1"
    local test_name="$2"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ -d "$dir_path" ]; then
        print_color "$GREEN" "✓ PASS: $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        TEST_RESULTS+=("PASS: $test_name")
        return 0
    else
        print_color "$RED" "✗ FAIL: $test_name"
        print_color "$RED" "  Directory not found: $dir_path"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        TEST_RESULTS+=("FAIL: $test_name")
        return 1
    fi
}

# Function to assert command exit code
assert_exit_code() {
    local expected_code="$1"
    local actual_code="$2"
    local test_name="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ "$expected_code" -eq "$actual_code" ]; then
        print_color "$GREEN" "✓ PASS: $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        TEST_RESULTS+=("PASS: $test_name")
        return 0
    else
        print_color "$RED" "✗ FAIL: $test_name"
        print_color "$RED" "  Expected exit code: $expected_code"
        print_color "$RED" "  Actual exit code:   $actual_code"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        TEST_RESULTS+=("FAIL: $test_name")
        return 1
    fi
}

# Function to run a test suite
run_test_suite() {
    local suite_name="$1"
    local test_file="$2"
    
    print_color "$BLUE" "\n=== Running Test Suite: $suite_name ==="
    
    if [ -f "$test_file" ]; then
        source "$test_file"
    else
        print_color "$RED" "Test file not found: $test_file"
        return 1
    fi
}

# Function to print test summary
print_summary() {
    print_color "$BLUE" "\n=== Test Summary ==="
    print_color "$BLUE" "Total Tests: $TOTAL_TESTS"
    print_color "$GREEN" "Passed: $PASSED_TESTS"
    print_color "$RED" "Failed: $FAILED_TESTS"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        print_color "$GREEN" "\n🎉 All tests passed!"
        return 0
    else
        print_color "$RED" "\n❌ Some tests failed!"
        return 1
    fi
}

# Setup test environment
setup_test_env() {
    local test_dir="$1"
    mkdir -p "$test_dir"
    cd "$test_dir"
}

# Cleanup test environment
cleanup_test_env() {
    local test_dir="$1"
    if [ -d "$test_dir" ]; then
        rm -rf "$test_dir"
    fi
}

# Export functions for use in test files
export -f assert_equals
export -f assert_file_exists
export -f assert_dir_exists
export -f assert_exit_code
export -f print_color
export -f setup_test_env
export -f cleanup_test_env
