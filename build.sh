#!/bin/bash

# Build Script for Pipeline Test
# This script handles the build process for the project

set -e  # Exit on any error
set -u  # Exit on undefined variables

echo "🔨 Starting build process..."

# Create build directory if it doesn't exist
mkdir -p build

# Simulate build steps
echo "📦 Installing dependencies..."
sleep 1

echo "🏗️  Compiling source code..."
sleep 2

echo "📄 Generating build artifacts..."
echo "Build completed at $(date)" > build/build-info.txt
echo "Build version: 1.0.0" >> build/build-info.txt
echo "Git commit: $(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')" >> build/build-info.txt

# Create a simple artifact
echo '{"status": "success", "version": "1.0.0", "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > build/manifest.json

echo "✅ Build completed successfully!"
echo "📋 Build artifacts created in ./build/ directory"
