pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// CPU and RAM usage as whole percentages, read from /proc every 2 seconds
Singleton {
  id: root
  property int cpu: 0
  property int ram: 0

  // CPU time counters from the previous read; usage is the share of the
  // time since then that wasn't spent idle
  property real lastTotal: 0
  property real lastIdle: 0

  FileView {
    id: stat
    path: "/proc/stat"
    onLoaded: {
      // First line: "cpu user nice system idle iowait irq softirq steal guest guest_nice".
      // guest and guest_nice are already counted in user and nice, so they're left out.
      const fields = stat.text().split("\n")[0].trim().split(/\s+/).slice(1, 9).map(Number)
      const total = fields.reduce((sum, n) => sum + n, 0)
      const idle = fields[3] + fields[4] // idle + iowait
      if (root.lastTotal > 0 && total > root.lastTotal) {
        root.cpu = Math.round(100 * (1 - (idle - root.lastIdle) / (total - root.lastTotal)))
      }
      root.lastTotal = total
      root.lastIdle = idle
    }
  }

  FileView {
    id: meminfo
    path: "/proc/meminfo"
    onLoaded: {
      const text = meminfo.text()
      const kb = name => Number(text.match(new RegExp(`^${name}:\\s+(\\d+)`, "m"))[1])
      root.ram = Math.round(100 * (1 - kb("MemAvailable") / kb("MemTotal")))
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      stat.reload()
      meminfo.reload()
    }
  }
}
