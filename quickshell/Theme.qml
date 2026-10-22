pragma Singleton

import Quickshell
import QtQuick

// The bar's colors, each one taken from the Catppuccin palette in Catppuccin.qml
Singleton {
  readonly property color background: Catppuccin.base
  readonly property color text: Catppuccin.text
  readonly property color muted: Catppuccin.overlay0
  readonly property color accent: Catppuccin.mauve
}
