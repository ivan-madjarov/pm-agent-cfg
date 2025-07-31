#!/bin/bash
# PM+ Agent Configuration - Linux Build Script
# Copyright (c) 2024-2025 Mitel Networks Corporation

set -e

echo "Building PM+ Agent Configuration for Linux..."

# Create build directory
BUILD_DIR="../../dist/linux"
mkdir -p "$BUILD_DIR"

# Make script executable
chmod +x pm-agent-config.sh

# Copy main script
cp pm-agent-config.sh "$BUILD_DIR/"

echo "[OK] Linux build completed successfully!"
echo "Output: $BUILD_DIR/pm-agent-config.sh"
echo ""
echo "CRITICAL: This script requires sudo privileges!"
echo "Usage: sudo $BUILD_DIR/pm-agent-config.sh --help"

