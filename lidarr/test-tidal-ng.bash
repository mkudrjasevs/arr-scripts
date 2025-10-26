#!/bin/bash

echo "Testing tidal-dl-ng installation..."

# Test if tidal-dl-ng is available
if command -v tidal-dl-ng &> /dev/null; then
    echo "✓ tidal-dl-ng command found"
    
    # Test basic help command
    echo "Testing basic help command..."
    tidal-dl-ng --help
    
    if [ $? -eq 0 ]; then
        echo "✓ tidal-dl-ng help command works"
    else
        echo "✗ tidal-dl-ng help command failed"
        exit 1
    fi
    
    # Test configuration command
    echo "Testing configuration command..."
    tidal-dl-ng cfg
    
    if [ $? -eq 0 ]; then
        echo "✓ tidal-dl-ng cfg command works"
    else
        echo "✗ tidal-dl-ng cfg command failed"
        exit 1
    fi
    
else
    echo "✗ tidal-dl-ng command not found"
    exit 1
fi

echo "All tests passed! tidal-dl-ng is working correctly."