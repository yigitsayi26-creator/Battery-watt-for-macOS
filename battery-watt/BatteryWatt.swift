import Cocoa
import IOKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateBattery()
        let t = Timer(timeInterval: 1.0, repeats: true) { _ in
            self.updateBattery()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func getBatteryInfo() -> (watt: Double, voltage: Double, current: Int, cap: Int, maxCap: Int, designCap: Int, charging: Bool)? {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard service != 0 else { return nil }
        defer { IOObjectRelease(service) }

        func prop(_ key: String) -> Int? {
            return IORegistryEntryCreateCFProperty(service, key as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? Int
        }

        guard let v = prop("Voltage"),
              let rawA = prop("Amperage") ?? prop("InstantAmperage"),
              let cap = prop("CurrentCapacity"),
              let maxCap = prop("MaxCapacity"),
              let designCap = prop("DesignCapacity") else { return nil }

        let a = Int64(bitPattern: UInt64(bitPattern: Int64(rawA)))
        let watt = abs(Double(v) * Double(a)) / 1_000_000.0
        return (watt, Double(v) / 1000.0, Int(abs(a)), cap, maxCap, designCap, a > 0)
    }

    @objc func updateBattery() {
        let menu = NSMenu()
        if let info = getBatteryInfo() {
            let icon = info.charging ? "🔌" : "⚡"
            statusItem.button?.title = String(format: "%@ %.2fW", icon, info.watt)

            let remWh = (Double(info.cap) * info.voltage) / 1000.0
            let health = (Double(info.maxCap) / Double(info.designCap)) * 100.0
            let statusText = info.charging ? "Charging" : "On Battery"

            menu.addItem(NSMenuItem(title: "BatteryWatt — Live Power Monitor", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: String(format: "Status: %@", statusText), action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: String(format: "Total Power: %.2f W", info.watt), action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: String(format: "Voltage / Current: %.2f V  |  %d mA", info.voltage, info.current), action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: String(format: "Remaining: %.1f Wh (%d / %d mAh)", remWh, info.cap, info.maxCap), action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: String(format: "Battery Health: %.1f%%", health), action: nil, keyEquivalent: ""))

            if !info.charging && info.watt > 0.1 {
                let hours = remWh / info.watt
                let h = Int(hours)
                let m = Int((hours - Double(h)) * 60)
                menu.addItem(NSMenuItem(title: String(format: "Est. Time Left: ~%dh %dm", h, m), action: nil, keyEquivalent: ""))
            }
        } else {
            statusItem.button?.title = "⚡ --W"
        }
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
