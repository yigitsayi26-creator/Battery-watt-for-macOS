[README.md](https://github.com/user-attachments/files/34997451/README.md)
# ⚡ BatteryWatt

Lightweight, zero-dependency macOS menu bar utility written in pure Swift (`IOKit`) to monitor real-time total system battery wattage, voltage, current, battery health, and estimated remaining runtime. Works on both Hackintosh laptops and real MacBooks.

## Features
- **Live Total System Wattage (`⚡ X.XXW` / `🔌 X.XXW`)** in the macOS menu bar
- **Real-time Voltage (V) & Current (mA)** directly from `AppleSmartBattery` (`IOKit`)
- **Remaining Capacity (Wh & mAh)** and **Battery Health (%)**
- **Dynamic Remaining Time Estimate** while discharging
- **Zero Overhead:** Pure Swift + Cocoa (`~0%` CPU), no Dock icon (`LSUIElement`)

## Quick Install (Pre-built)
1. Download **`BatteryWatt.app.zip`** from the repository or **Releases**.
2. Unzip and move **`BatteryWatt.app`** to `/Applications`.
3. Right-click **`BatteryWatt.app` -> Open** on first launch (to bypass Gatekeeper for unsigned apps).

## Build from Source
```bash
chmod +x build.sh
./build.sh
cp -r BatteryWatt.app /Applications/
```

## Auto-Start on Login
Add **`BatteryWatt.app`** to **System Settings -> General -> Login Items**.
