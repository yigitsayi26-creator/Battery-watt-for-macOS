#!/bin/bash
mkdir -p BatteryWatt.app/Contents/MacOS
cat << 'PLIST' > BatteryWatt.app/Contents/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://apple.com">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>BatteryWatt</string>
    <key>CFBundleIdentifier</key>
    <string>com.yigit.BatteryWatt</string>
    <key>CFBundleName</key>
    <string>BatteryWatt</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
PLIST
swiftc BatteryWatt.swift -o BatteryWatt.app/Contents/MacOS/BatteryWatt
echo "BatteryWatt.app successfully built!"
