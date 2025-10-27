#!/bin/bash

echo "=== Configuring FFmpeg for tidal-dl-ng ==="

# Check if tidal-dl-ng is available
if ! command -v tidal-dl-ng &> /dev/null; then
    echo "ERROR: tidal-dl-ng command not found!"
    echo "Please run the setup script first to install tidal-dl-ng."
    exit 1
fi

# Check if ffmpeg is available
if ! command -v ffmpeg &> /dev/null; then
    echo "ERROR: ffmpeg command not found!"
    echo "Please install ffmpeg first (should be installed via setup.bash)."
    exit 1
fi

# Get the FFmpeg path
FFMPEG_PATH=$(which ffmpeg)
echo "Found FFmpeg at: $FFMPEG_PATH"

# Configure tidal-dl-ng to use the FFmpeg binary
echo "Configuring tidal-dl-ng to use FFmpeg..."
tidal-dl-ng cfg path_binary_ffmpeg "$FFMPEG_PATH"

# Verify the configuration
echo ""
echo "Verifying FFmpeg configuration..."
if tidal-dl-ng cfg | grep -q "path_binary_ffmpeg"; then
    echo "✓ FFmpeg path configured successfully"
    echo ""
    echo "Current tidal-dl-ng configuration:"
    tidal-dl-ng cfg | grep -A 1 -B 1 "path_binary_ffmpeg"
else
    echo "✗ Failed to configure FFmpeg path"
    exit 1
fi

echo ""
echo "✓ FFmpeg configuration complete!"
echo "tidal-dl-ng should now be able to process video files and extract FLAC from MP4 containers."