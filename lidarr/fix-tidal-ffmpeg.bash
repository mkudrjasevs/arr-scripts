#!/bin/bash

echo "=== Fixing FFmpeg Python Package Conflicts ==="

echo "Current Python FFmpeg packages:"
python3 -c "
import pkg_resources
ffmpeg_packages = [pkg for pkg in pkg_resources.working_set if 'ffmpeg' in pkg.key.lower()]
if ffmpeg_packages:
    for pkg in ffmpeg_packages:
        print(f'  {pkg.key}: {pkg.version} at {pkg.location}')
else:
    print('  No ffmpeg packages found')
" 2>/dev/null || echo "Failed to check packages"

echo ""
echo "Testing current FFmpeg import..."
python3 -c "
try:
    from ffmpeg import FFmpeg
    print('✓ FFmpeg import successful')
except ImportError as e:
    print(f'✗ FFmpeg import failed: {e}')
except Exception as e:
    print(f'✗ Unexpected error: {e}')
"

echo ""
echo "Fixing FFmpeg package conflicts..."

# Remove the wrong ffmpeg package if it exists
echo "Removing conflicting ffmpeg packages..."
uv pip uninstall --system ffmpeg -y 2>/dev/null || true
pip uninstall ffmpeg -y 2>/dev/null || true

# Install the correct ffmpeg-python package
echo "Installing correct ffmpeg-python package..."
if uv pip install --system --upgrade --no-cache-dir --break-system-packages --force-reinstall ffmpeg-python 2>/dev/null; then
    echo "✓ Successfully installed ffmpeg-python with uv"
elif pip install --upgrade --force-reinstall ffmpeg-python 2>/dev/null; then
    echo "✓ Successfully installed ffmpeg-python with pip"
else
    echo "✗ Failed to install ffmpeg-python"
    exit 1
fi

echo ""
echo "Testing FFmpeg import after fix..."
python3 -c "
try:
    from ffmpeg import FFmpeg
    print('✓ FFmpeg import successful after fix!')
except ImportError as e:
    print(f'✗ FFmpeg import still failing: {e}')
    exit(1)
except Exception as e:
    print(f'✗ Unexpected error: {e}')
    exit(1)
"

echo ""
echo "Testing tidal-dl-ng import..."
python3 -c "
try:
    from tidal_dl_ng.cli import app
    print('✓ tidal-dl-ng import successful!')
except ImportError as e:
    print(f'✗ tidal-dl-ng import failed: {e}')
    exit(1)
except Exception as e:
    print(f'✗ Unexpected error: {e}')
    exit(1)
"

echo ""
echo "✓ FFmpeg package conflicts resolved!"
echo "tidal-dl-ng should now work correctly."