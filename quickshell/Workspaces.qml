import Quickshell
import Quickshell.Hyprland
import QtQuick

// Workspaces 1-10, the ones SUPER + 1-0 reach; click one to switch to it
Item {
  id: root
  required property ShellScreen screen

  readonly property var monitor: Hyprland.monitorFor(screen)

  implicitWidth: numbers.implicitWidth

  Row {
    id: numbers

    Repeater {
      id: repeater
      model: 10

      Text {
        required property int index // receive the number Repeater gives

        readonly property int workspaceId: index + 1
        readonly property var workspace: Hyprland.workspaces.values.find(ws => ws.id === workspaceId)
        readonly property bool occupied: workspace?.toplevels.values.length > 0

        height: root.height
        leftPadding: 8
        rightPadding: 8
        verticalAlignment: Text.AlignVCenter
        color: occupied ? Theme.text : Theme.muted
        text: workspaceId

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${parent.workspaceId} })`)
        }
      }
    }
  }

  // Underlines the active workspace and slides to the new one when you switch
  Rectangle {
    // Reading count re-runs this once the numbers exist; null when the active workspace isn't 1-10
    readonly property Item target: repeater.count > 0
      ? repeater.itemAt((root.monitor?.activeWorkspace?.id ?? 0) - 1)
      : null

    visible: target !== null
    x: target ? target.x + target.leftPadding : 0
    y: (root.height + (target?.contentHeight ?? 0)) / 2
    width: target?.contentWidth ?? 0
    height: 2
    radius: 1
    color: Theme.accent

    Behavior on x {
      NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }
    Behavior on width {
      NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }
  }
}
