#!/bin/bash
# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

USER_FACE="$HOME/.face"

echo "🖼️  Checking user avatar setup..."

if [ -f "$USER_FACE" ]; then
  echo "✅ User avatar found at ~/.face"
  file "$USER_FACE"
else
  echo "❌ No user avatar found at ~/.face"
  echo ""
  echo "📋 To add your avatar:"
  echo "   1. Copy your profile picture to ~/.face"
  echo "   2. Recommended formats: PNG, JPG (square image works best)"
  echo "   3. Recommended size: 200x200 pixels or larger"
  echo ""
  echo "Example commands:"
  echo "   cp /path/to/your/photo.jpg ~/.face"
  echo "   # or"
  echo "   wget -O ~/.face 'https://github.com/yourusername.png'"
  echo ""
  echo "🔄 The lock screen will use a fallback user icon if no ~/.face is found"
fi

# Check image dimensions if file exists
if [ -f "$USER_FACE" ] && command -v identify &>/dev/null; then
  echo ""
  echo "🔍 Image details:"
  identify "$USER_FACE"
fi
