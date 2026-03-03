#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "Building ThumbnailMaker..."
swift build

# Find the built binary
BINARY=$(find .build -path "*/debug/ThumbnailMaker" -not -path "*.dSYM*" -type f | head -1)
if [ -z "$BINARY" ]; then
    echo "Error: Build binary not found"
    exit 1
fi

echo "Creating .app bundle..."
APP_DIR="ThumbnailMaker.app/Contents"
mkdir -p "$APP_DIR/MacOS"

cp "$BINARY" "$APP_DIR/MacOS/ThumbnailMaker"

cat > "$APP_DIR/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ThumbnailMaker</string>
    <key>CFBundleIdentifier</key>
    <string>com.nozium.thumbnail-maker</string>
    <key>CFBundleName</key>
    <string>Thumbnail Maker</string>
    <key>CFBundleDisplayName</key>
    <string>Thumbnail Maker</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.graphics-design</string>
</dict>
</plist>
PLIST

echo ""
echo "Build complete!"
echo "  App: $(pwd)/ThumbnailMaker.app"
echo ""
echo "To run:  open ThumbnailMaker.app"
echo "To install: cp -r ThumbnailMaker.app /Applications/"
