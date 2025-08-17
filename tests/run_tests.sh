#!/bin/bash

# Main test runner for all media conversion scripts
# This script runs all unit tests and provides a comprehensive report

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Import test framework
source "$SCRIPT_DIR/test_framework.sh"

# Color definitions (from framework)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Global test statistics
TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

print_header() {
    echo
    print_color "$CYAN" "=========================================="
    print_color "$CYAN" "  Media Conversion Scripts - Test Suite  "
    print_color "$CYAN" "=========================================="
    echo
    print_color "$BLUE" "Project Directory: $PROJECT_DIR"
    print_color "$BLUE" "Test Directory: $SCRIPT_DIR"
    echo
}

check_dependencies() {
    print_color "$BLUE" "=== Checking Dependencies ==="
    
    # Check if cwebp is available
    if command -v cwebp >/dev/null 2>&1; then
        print_color "$GREEN" "✓ cwebp found: $(which cwebp)"
    else
        print_color "$YELLOW" "⚠ cwebp not found - image conversion tests may show warnings"
    fi
    
    # Check if ffmpeg is available
    if command -v ffmpeg >/dev/null 2>&1; then
        print_color "$GREEN" "✓ ffmpeg found: $(which ffmpeg)"
    else
        print_color "$YELLOW" "⚠ ffmpeg not found - video conversion tests may show warnings"
    fi
    
    echo
}

run_script_tests() {
    local suite_name="$1"
    local test_file="$2"
    
    print_color "$BLUE" "\n=== Running Test Suite: $suite_name ==="
    
    TOTAL_SUITES=$((TOTAL_SUITES + 1))
    
    # Reset test counters for this suite
    local suite_start_total=$TOTAL_TESTS
    local suite_start_passed=$PASSED_TESTS
    local suite_start_failed=$FAILED_TESTS
    
    if [ -f "$test_file" ]; then
        # Make test file executable
        chmod +x "$test_file"
        
        # Source and run the test file
        source "$test_file"
        
        # Calculate suite statistics
        local suite_total=$((TOTAL_TESTS - suite_start_total))
        local suite_passed=$((PASSED_TESTS - suite_start_passed))
        local suite_failed=$((FAILED_TESTS - suite_start_failed))
        
        print_color "$BLUE" "Suite Results: $suite_passed/$suite_total passed"
        
        if [ $suite_failed -eq 0 ]; then
            print_color "$GREEN" "✓ $suite_name: ALL TESTS PASSED"
            PASSED_SUITES=$((PASSED_SUITES + 1))
        else
            print_color "$RED" "✗ $suite_name: $suite_failed TESTS FAILED"
            FAILED_SUITES=$((FAILED_SUITES + 1))
        fi
    else
        print_color "$RED" "✗ Test file not found: $test_file"
        FAILED_SUITES=$((FAILED_SUITES + 1))
    fi
}

run_integration_tests() {
    print_color "$BLUE" "\n=== Running Integration Tests ==="
    
    # Test that all scripts exist and are executable
    local scripts=("convertImageToWebp.sh" "convertVideoToWebm.sh" "addPrefixToFilename.sh")
    
    for script in "${scripts[@]}"; do
        local script_path="$PROJECT_DIR/$script"
        assert_file_exists "$script_path" "Script exists: $script"
        
        if [ -x "$script_path" ]; then
            assert_equals "1" "1" "Script is executable: $script"
        else
            assert_equals "1" "0" "Script is executable: $script"
        fi
    done
    
    # Test that documentation exists
    local docs=("README.md" "docs/README-convertImageToWebp.md" "docs/README-convertVideoToWebm.md" "docs/README-addPrefixToFilename.md")
    
    for doc in "${docs[@]}"; do
        local doc_path="$PROJECT_DIR/$doc"
        assert_file_exists "$doc_path" "Documentation exists: $doc"
    done
}

print_final_summary() {
    print_color "$CYAN" "\n=========================================="
    print_color "$CYAN" "           FINAL TEST REPORT             "
    print_color "$CYAN" "=========================================="
    
    print_color "$BLUE" "\nTest Suites Summary:"
    print_color "$BLUE" "Total Suites: $TOTAL_SUITES"
    print_color "$GREEN" "Passed Suites: $PASSED_SUITES"
    print_color "$RED" "Failed Suites: $FAILED_SUITES"
    
    print_color "$BLUE" "\nIndividual Tests Summary:"
    print_color "$BLUE" "Total Tests: $TOTAL_TESTS"
    print_color "$GREEN" "Passed Tests: $PASSED_TESTS"
    print_color "$RED" "Failed Tests: $FAILED_TESTS"
    
    local success_rate=0
    if [ $TOTAL_TESTS -gt 0 ]; then
        success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    fi
    
    print_color "$BLUE" "Success Rate: ${success_rate}%"
    
    if [ $FAILED_TESTS -eq 0 ] && [ $FAILED_SUITES -eq 0 ]; then
        print_color "$GREEN" "\n🎉 ALL TESTS PASSED! 🎉"
        print_color "$GREEN" "The media conversion scripts are working correctly."
        echo
        return 0
    else
        print_color "$RED" "\n❌ SOME TESTS FAILED!"
        print_color "$RED" "Please review the failed tests above."
        echo
        return 1
    fi
}

# Main execution
main() {
    print_header
    check_dependencies
    
    # Run individual script tests
    run_script_tests "Image Conversion Tests" "$SCRIPT_DIR/test_convertImageToWebp.sh"
    run_script_tests "Video Conversion Tests" "$SCRIPT_DIR/test_convertVideoToWebm.sh"  
    run_script_tests "Filename Prefix Tests" "$SCRIPT_DIR/test_addPrefixToFilename.sh"
    
    # Run integration tests
    run_integration_tests
    
    # Print final summary
    print_final_summary
}

# Make all test files executable
chmod +x "$SCRIPT_DIR"/*.sh

# Run main function
main "$@"
