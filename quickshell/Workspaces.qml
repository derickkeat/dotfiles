import Quickshell
import Quickshell.Hyprland
import QtQuick

// Workspaces 1-10, the ones SUPER + 1-0 reach; click one to switch to it
Row {
  id: root
  required property ShellScreen screen

  readonly property var monitor: Hyprland.monitorFor(screen)

  Repeater {
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
      color: root.monitor?.activeWorkspace?.id === workspaceId ? Theme.accent
        : occupied ? Theme.text
        : Theme.muted
      text: workspaceId

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${parent.workspaceId} })`)
      }
    }
  }
}
