#!/bin/bash
# Linux build script

set -e

echo "Building PM+ Agent for Linux..."

# Create build directory
mkdir -p ../../dist/linux

# Make scripts executable
chmod +x pm-agent-config.sh

# Copy scripts to build directory
cp pm-agent-config.sh ../../dist/linux/

echo "Linux build completed successfully!"
echo "Main script: ../../dist/linux/pm-agent-config.sh"
echo ""
echo "Usage:"
echo "  sudo ../../dist/linux/pm-agent-config.sh --help"

