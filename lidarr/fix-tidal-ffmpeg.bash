#!/bin/bash

echo "=== Fixing tidal-dl-ng FFmpeg dependency in Docker container ==="

# Check what Python is available
echo "Checking Python environment..."
which python3 2>/dev/null && echo "✓ python3 found at: $(which python3)" || echo "✗ python3 not found"
which python 2>/dev/null && echo "✓ python found at: $(which python)" || echo "✗ python not found"
which uv 2>/dev/null && echo "✓ uv found at: $(which uv)" || echo "✗ uv not found"

echo ""
echo "Checking current ffmpeg packages..."
python3 -c "
import pkg_resources
ffmpeg_packages = [pkg for pkg in pkg_resources.working_set if 'ffmpeg' in pkg.key.lower()]
if ffmpeg_packages:
    print('Found ffmpeg packages:')
    for pkg in ffmpeg_packages:
        print(f'  {pkg.key}: {pkg.version}')
else:
    print('No ffmpeg packages found')
" 2>/dev/null || echo "Failed to check packages"

echo ""
echo "Testing tidal-dl-ng import..."
python3 -c "
try:
    from ffmpeg import FFmpeg
    print('✓ FFmpeg import successful')
except ImportError as e:
    print(f'✗ FFmpeg import failed: {e}')
    
try:
    from tidal_dl_ng.cli import app
    print('✓ tidal-dl-ng import successful')
except ImportError as e:
    print(f'✗ tidal-dl-ng import failed: {e}')
"

echo ""
echo "Attempting to fix with uv..."

# Try to install ffmpeg-python with uv
if uv pip install --system --upgrade ffmpeg-python 2>/dev/null; then
    echo "✓ Successfully installed ffmpeg-python with uv"
else
    echo "✗ Failed to install ffmpeg-python with uv"
fi

# Try to reinstall tidal-dl-ng
if uv pip install --system --upgrade --force-reinstall tidal-dl-ng 2>/dev/null; then
    echo "✓ Successfully reinstalled tidal-dl-ng with uv"
else
    echo "✗ Failed to reinstall tidal-dl-ng with uv"
fi

echo ""
echo "Testing tidal-dl-ng again..."
if python3 -c "from tidal_dl_ng.cli import app; print('✓ tidal-dl-ng imports successfully')" 2>/dev/null; then
    echo "✓ tidal-dl-ng is working correctly!"
    
    # Test the command
    if tidal-dl-ng --version 2>/dev/null; then
        echo "✓ tidal-dl-ng command works!"
    else
        echo "✗ tidal-dl-ng command failed"
    fi
else
    echo "✗ tidal-dl-ng still has import issues"
fi

echo ""
echo "=== Fix attempt completed ==="