#!/bin/bash

set -e

echo "🔍 Running verification..."

# Check build artifacts
[ -d "build" ] || { echo "❌ Build directory missing"; exit 1; }
[ -f "build/build-info.txt" ] || { echo "❌ build-info.txt missing"; exit 1; }
[ -f "build/manifest.json" ] || { echo "❌ manifest.json missing"; exit 1; }

# Validate JSON
python3 -c "import json; json.load(open('build/manifest.json'))" || { echo "❌ Invalid JSON"; exit 1; }

# Check build status
status=$(python3 -c "import json; print(json.load(open('build/manifest.json'))['status'])")
[ "$status" = "success" ] || { echo "❌ Build failed"; exit 1; }

echo "✅ Verification passed"
