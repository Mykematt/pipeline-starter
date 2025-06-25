#!/bin/bash

set -e

echo "Testing output..."

# Test the file content
[ "$(cat output.txt)" = "output-data" ]

echo "Test passed"

# INTENTIONALLY BREAK VERIFICATION TO TEST STEP 3
echo "Breaking verification intentionally..."
echo "This will cause verification to fail so we can test the manual override in step 3."
exit 1
