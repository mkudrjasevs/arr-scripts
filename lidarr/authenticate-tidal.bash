#!/bin/bash

echo "=== TIDAL Authentication Helper ==="
echo ""
echo "This script will help you authenticate with TIDAL for tidal-dl-ng."
echo "You'll need your TIDAL Premium or HiFi account credentials."
echo ""

# Check if tidal-dl-ng is available
if ! command -v tidal-dl-ng &> /dev/null; then
    echo "ERROR: tidal-dl-ng command not found!"
    echo "Please run the setup script first to install tidal-dl-ng."
    exit 1
fi

# Check current authentication status
echo "Checking current authentication status..."
if tidal-dl-ng cfg 2>&1 | grep -q "login"; then
    echo "✓ Already authenticated with TIDAL"
    echo ""
    echo "Current configuration:"
    tidal-dl-ng cfg
    echo ""
    read -p "Do you want to re-authenticate? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Authentication skipped."
        exit 0
    fi
else
    echo "✗ Not authenticated with TIDAL"
fi

echo ""
echo "Starting TIDAL authentication..."
echo "Please follow the prompts to log in with your TIDAL account."
echo ""

# Start the authentication process
tidal-dl-ng login

# Check if authentication was successful
echo ""
echo "Checking authentication status..."
if tidal-dl-ng cfg 2>&1 | grep -q "login"; then
    echo "✓ Successfully authenticated with TIDAL!"
    
    # Configure some basic settings for the arr-scripts environment
    echo ""
    echo "Configuring tidal-dl-ng for arr-scripts..."
    
    # Set audio quality to highest available
    tidal-dl-ng cfg audio_quality "HiRes FLAC"
    
    # Set video quality
    tidal-dl-ng cfg video_quality "1080p"
    
    # Show final configuration
    echo ""
    echo "Final configuration:"
    tidal-dl-ng cfg
    
    echo ""
    echo "✓ TIDAL authentication and configuration complete!"
    echo "You can now run the Audio.service.bash script."
    
else
    echo "✗ Authentication failed or incomplete."
    echo "Please try running this script again."
    exit 1
fi