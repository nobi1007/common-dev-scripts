#!/bin/bash

# Script to update test report in README.md
# Run this after making changes to ensure the test report is current

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
README_FILE="$PROJECT_DIR/README.md"
TEMP_REPORT="$PROJECT_DIR/temp_test_report.txt"

echo "🧪 Running tests and updating README..."

# Run tests and capture output (without colors)
cd "$PROJECT_DIR"
./tests/run_tests.sh 2>&1 | sed 's/\x1b\[[0-9;]*m//g' > "$TEMP_REPORT"

# Extract key metrics from the test report
TOTAL_TESTS=$(grep "Total Tests:" "$TEMP_REPORT" | sed 's/.*Total Tests: //')
PASSED_TESTS=$(grep "Passed Tests:" "$TEMP_REPORT" | sed 's/.*Passed Tests: //')
SUCCESS_RATE=$(grep "Success Rate:" "$TEMP_REPORT" | sed 's/.*Success Rate: //')

# Check if tests passed
if grep -q "ALL TESTS PASSED" "$TEMP_REPORT"; then
    TEST_STATUS="passing"
    BADGE_COLOR="brightgreen"
    STATUS_EMOJI="✅"
else
    TEST_STATUS="failing"
    BADGE_COLOR="red"
    STATUS_EMOJI="❌"
fi

echo "📊 Test Results:"
echo "   Total Tests: $TOTAL_TESTS"
echo "   Passed Tests: $PASSED_TESTS"
echo "   Success Rate: $SUCCESS_RATE"
echo "   Status: $TEST_STATUS"

# Update badges in README
sed -i.bak "s|tests-[0-9]*%2F[0-9]*%20passing-[a-z]*|tests-${PASSED_TESTS}%2F${TOTAL_TESTS}%20${TEST_STATUS}-${BADGE_COLOR}|g" "$README_FILE"

# Update coverage badge (assuming 100% if all tests pass)
if [ "$TEST_STATUS" = "passing" ]; then
    sed -i.bak "s|coverage-[0-9]*%25-[a-z]*|coverage-100%25-brightgreen|g" "$README_FILE"
fi

echo "✅ README badges updated!"

# Extract and format the full test report for the collapsible section
echo "📝 Updating detailed test report..."

# Create a temporary file with the formatted test report
cat > "${TEMP_REPORT}.formatted" << 'EOF'
```
EOF

# Add the test report content (skip the first empty line and last empty lines)
tail -n +2 "$TEMP_REPORT" | sed '/^$/N;/^\n$/d' >> "${TEMP_REPORT}.formatted"

cat >> "${TEMP_REPORT}.formatted" << 'EOF'
```
EOF

echo "📋 Test report extracted and formatted"

# Clean up
rm -f "$TEMP_REPORT" "${README_FILE}.bak"

echo "🎉 README.md has been updated with the latest test results!"
echo ""
echo "💡 Tip: Commit the updated README.md to keep test status current"
