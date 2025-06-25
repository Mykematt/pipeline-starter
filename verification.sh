#!/bin/bash

set -e

echo "Testing output..."

# Test the file content
[ "$(cat output.txt)" = "output-data" ]

echo "Test passed"
