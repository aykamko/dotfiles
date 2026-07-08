// zed-window-borders — draw a colored border around specific Zed windows,
// identified by CoreGraphics window number via a launch-capture map.
//
// Zed exposes nothing per-window to tell remote devboxes apart (every title is
// "figma", windows stack at the same frame). So `zed-devboxes` records, at
// launch, which window NUMBER belongs to which devbox color into map.json, and
// this daemon paints borders from that map. Window numbers are the only stable
// per-window handle macOS gives across processes.
//
// Reads geometry via CGWindowList (no Accessibility / Screen Recording needed).
// Self-exits when Zed is no longer running, so `zed-devboxes` can spawn it
// lazily with no launchd agent. Build:
//   swiftc -O zed-window-borders.swift -o zed-window-borders
//
//   zed-window-borders            run the border daemon
//   zed-window-borders --windows  print current Zed window numbers (for capture)
//   zed-window-borders --list     print each Zed window: number, frame, mapped?
import Cocoa

// ---------- Config ----------
let ZED_BUNDLE_ID = "dev.zed.Zed"
let BORDER_WIDTH: CGFloat = 4.0
let TICK: TimeInterval = 0.08   // reconcile cadence; higher = less CPU, more lag

let CACHE = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".cache/zed-window-borders")
let MAP_PATH = CACHE.appendingPathComponent("map.json").path

func hex(_ v: Int) -> NSColor {
  NSColor(srgbRed: CGFloat((v >> 16) & 0xFF) / 255.0,
          green:   CGFloat((v >> 8)  & 0xFF) / 255.0,
          blue:    CGFloat(v & 0xFF)         / 255.0, alpha: 1.0)
}

// color name (as written into map.json) -> border color
let COLOR_MAP: [String: NSColor] = [
  "blue":   hex(0x1E6FD9),
  "green":  hex(0x2EA043),
  "purple": hex(0x8B5CF6),
  "orange": hex(0xFB8500),
  "cyan":   hex(0x22D3EE),
  "yellow": hex(0xEAB308),
  "red":    hex(0xEF4444),
]

// ---------- Window enumeration (CoreGraphics) ----------
func zedApp() -> NSRunningApplication? {
  NSRunningApplication.runningApplications(withBundleIdentifier: ZED_BUNDLE_ID).first
}

func zedWindows() -> [(number: Int, frame: CGRect)] {
  guard let pid = zedApp()?.processIdentifier else { return [] }
  let info = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
  var out: [(Int, CGRect)] = []
  for w in info {
    guard (w[kCGWindowOwnerPID as String] as? pid_t) == pid,
          (w[kCGWindowLayer as String] as? Int) == 0,
          let num = w[kCGWindowNumber as String] as? Int,
          let b = w[kCGWindowBounds as String] as? [String: CGFloat] else { continue }
    out.append((num, CGRect(x: b["X"] ?? 0, y: b["Y"] ?? 0, width: b["Width"] ?? 0, height: b["Height"] ?? 0)))
  }
  return out
}

// map.json is { "<windowNumber>": "<colorName>" }; reloaded each tick so windows
// captured mid-run get painted without restarting the daemon.
func loadMap() -> [Int: NSColor] {
  guard let data = FileManager.default.contents(atPath: MAP_PATH),
        let obj = (try? JSONSerialization.jsonObject(with: data)) as? [String: String] else { return [:] }
  var out: [Int: NSColor] = [:]
  for (k, v) in obj {
    if let n = Int(k), let c = COLOR_MAP[v.lowercased()] { out[n] = c }
  }
  return out
}

// CGWindow bounds use a top-left origin (y down from the primary display top);
// Cocoa windows use a bottom-left origin. Flip through the primary screen height.
func primaryHeight() -> CGFloat {
  (NSScreen.screens.first { $0.frame.origin == .zero } ?? NSScreen.main)?.frame.height ?? 0
}

func toCocoa(_ r: CGRect) -> CGRect {
  CGRect(x: r.origin.x, y: primaryHeight() - r.origin.y - r.size.height,
         width: r.size.width, height: r.size.height)
}

// ---------- Overlay ----------
final class BorderView: NSView {
  var color: NSColor = .red { didSet { needsDisplay = true } }
  override func draw(_ dirtyRect: NSRect) {
    color.setStroke()
    let path = NSBezierPath(rect: bounds.insetBy(dx: BORDER_WIDTH / 2, dy: BORDER_WIDTH / 2))
    path.lineWidth = BORDER_WIDTH
    path.stroke()
  }
}

final class BorderManager {
  // A single overlay: we only ever border the one active Zed window.
  private var overlay: NSWindow?
  private var shownNum: Int?   // window number currently bordered (nil = hidden)

  private func ensureOverlay() -> NSWindow {
    if let w = overlay { return w }
    let w = NSWindow(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
    w.isOpaque = false
    w.backgroundColor = .clear
    w.hasShadow = false
    w.ignoresMouseEvents = true
    w.level = .floating
    w.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
    w.contentView = BorderView(frame: .zero)
    overlay = w
    return w
  }

  func refresh() {
    guard zedApp() != nil else { NSApp.terminate(nil); return }
    let zedActive = NSWorkspace.shared.frontmostApplication?.bundleIdentifier == ZED_BUNDLE_ID
    // zedWindows() is front-to-back, so .first is the active (frontmost) window.
    let front = zedWindows().first
    let color = front.flatMap { loadMap()[$0.number] }

    // Border only when Zed is active AND its frontmost window is a mapped one.
    guard zedActive, let win = front, let color = color else {
      overlay?.orderOut(nil)
      shownNum = nil
      return
    }
    let frame = toCocoa(win.frame)
    let w = ensureOverlay()
    w.setFrame(frame, display: false)                                  // track moves/resizes
    w.contentView?.frame = NSRect(origin: .zero, size: frame.size)
    (w.contentView as? BorderView)?.color = color
    if shownNum != win.number || !w.isVisible {
      w.orderFrontRegardless()
      shownNum = win.number
    }
  }
}

// ---------- Entry ----------
if CommandLine.arguments.contains("--windows") {
  for w in zedWindows() { print(w.number) }
  exit(0)
}

if CommandLine.arguments.contains("--list") {
  let map = loadMap()
  let wins = zedWindows()
  if wins.isEmpty { print("(no Zed windows / Zed not running)") }
  for w in wins {
    let tag = map[w.number] != nil ? "colored " : "unmapped"
    print("num=\(w.number) [\(tag)] \(Int(w.frame.width))x\(Int(w.frame.height))@\(Int(w.frame.minX)),\(Int(w.frame.minY))")
  }
  exit(0)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let manager = BorderManager()
let timer = Timer(timeInterval: TICK, repeats: true) { _ in manager.refresh() }
RunLoop.main.add(timer, forMode: .common)
manager.refresh()
app.run()
