#!/bin/bash

# Development script for running quality checks and updating documentation
# This script helps maintain the project by running tests and updating docs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🚀 Running project quality checks..."
echo ""

# Function to print section headers
print_header() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Check if scripts are executable
print_header "📋 CHECKING SCRIPT PERMISSIONS"
for script in convertImageToWebp.sh convertVideoToWebm.sh addPrefixToFilename.sh; do
    if [ -x "$PROJECT_DIR/$script" ]; then
        echo "✅ $script is executable"
    else
        echo "⚠️  Making $script executable..."
        chmod +x "$PROJECT_DIR/$script"
        echo "✅ $script is now executable"
    fi
done
echo ""

# Run comprehensive tests
print_header "🧪 RUNNING COMPREHENSIVE TESTS"
cd "$PROJECT_DIR"
./tests/run_tests.sh
echo ""

# Update README with latest test results
print_header "📝 UPDATING DOCUMENTATION"
./scripts/update_test_report.sh
echo ""

# Check for any uncommitted changes
print_header "📊 GIT STATUS CHECK"
if command -v git >/dev/null 2>&1 && [ -d "$PROJECT_DIR/.git" ]; then
    cd "$PROJECT_DIR"
    if git diff --quiet && git diff --cached --quiet; then
        echo "✅ No uncommitted changes detected"
    else
        echo "⚠️  Uncommitted changes detected:"
        git status --porcelain
        echo ""
        echo "💡 Consider committing these changes:"
        echo "   git add ."
        echo "   git commit -m \"Update test results and documentation\""
    fi
else
    echo "ℹ️  Not a git repository or git not available"
fi
echo ""

# Summary
print_header "✨ QUALITY CHECK SUMMARY"
echo "🎯 All quality checks completed!"
echo ""
echo "📊 What was checked:"
echo "   • Script permissions and executability"
echo "   • Comprehensive test suite (65 tests)"
echo "   • Documentation freshness"
echo "   • Git repository status"
echo ""
echo "🎉 Your project is ready for use!"
echo ""
echo "💡 Quick commands:"
echo "   ./convertImageToWebp.sh <input> [output]    - Convert images to WebP"
echo "   ./convertVideoToWebm.sh <input> [output]    - Convert videos to WebM"
echo "   ./addPrefixToFilename.sh <prefix> <target>  - Add prefix to files"
echo "   ./tests/run_tests.sh                        - Run all tests"
echo ""
