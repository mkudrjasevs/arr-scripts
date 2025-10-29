#!/bin/bash

echo "=== Fixing tidal-dl-ng FFmpeg dependency issue ==="
echo ""

# Check current state
echo "Checking current Python FFmpeg packages..."
python3 -c "
import pkg_resources
ffmpeg_packages = [pkg for pkg in pkg_resources.working_set if 'ffmpeg' in pkg.key.lower()]
if ffmpeg_packages:
    print('Found FFmpeg-related packages:')
    for pkg in ffmpeg_packages:
        print(f'  {pkg.key}: {pkg.version}')
else:
    print('No FFmpeg-related packages found')
" 2>/dev/null || echo "Failed to check packages"

echo ""
echo "Attempting to fix the FFmpeg package conflict..."

# Remove the problematic ffmpeg package
echo "1. Removing conflicting 'ffmpeg' package..."
if uv pip uninstall --system ffmpeg --break-system-packages 2>/dev/null; then
    echo "✓ Successfully removed conflicting ffmpeg package"
else
    echo "ℹ ffmpeg package was not installed or already removed"
fi

# Install the correct ffmpeg-python package
echo "2. Installing correct 'ffmpeg-python' package..."
if uv pip install --system --upgrade --break-system-packages ffmpeg-python 2>/dev/null; then
    echo "✓ Successfully installed ffmpeg-python"
else
    echo "✗ Failed to install ffmpeg-python"
    exit 1
fi

# Reinstall tidal-dl-ng to ensure it uses the correct dependencies
echo "3. Reinstalling tidal-dl-ng to ensure correct dependencies..."
if uv pip install --system --upgrade --force-reinstall --break-system-packages tidal-dl-ng 2>/dev/null; then
    echo "✓ Successfully reinstalled tidal-dl-ng"
else
    echo "✗ Failed to reinstall tidal-dl-ng"
    exit 1
fi

echo ""
echo "=== Testing the fix ==="

# Test if tidal-dl-ng can import correctly now
echo "Testing tidal-dl-ng import..."
if python3 -c "from tidal_dl_ng.cli import app; print('✓ tidal-dl-ng imports successfully')" 2>/dev/null; then
    echo "✓ Import test passed!"
else
    echo "✗ Import test failed"
    exit 1
fi

# Test if tidal-dl-ng command works
echo "Testing tidal-dl-ng command..."
if tidal-dl-ng --version 2>/dev/null; then
    echo "✓ tidal-dl-ng command works!"
else
    echo "✗ tidal-dl-ng command failed"
    exit 1
fi

echo ""
echo "=== Fix completed successfully! ==="
echo "✓ Removed conflicting ffmpeg package"
echo "✓ Installed correct ffmpeg-python package" 
echo "✓ Reinstalled tidal-dl-ng with correct dependencies"
echo "✓ Verified tidal-dl-ng is working"
echo ""
echo "You can now use tidal-dl-ng without import errors!"
