pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  // an expression can be broken across multiple lines using {}
  readonly property string time: {
    // The passed format string matches the default output of
    // the `date` command, minus the timezone.
    Qt.formatDateTime(clock.date, "ddd MMM d hh:mm:ss AP yyyy")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
