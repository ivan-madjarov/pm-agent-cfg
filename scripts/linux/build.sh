#!/bin/bash
# Linux build script

set -e

echo "Building PM+ Agent for Linux..."

# Create build directory
mkdir -p dist/linux

# Build common components
python3 -m py_compile src/common/*.py

# Build Linux-specific components  
python3 -m py_compile src/linux/*.py

# Copy configuration files
cp -r config/linux/* dist/linux/
cp -r config/common/* dist/linux/

echo "Linux build completed successfully!"

