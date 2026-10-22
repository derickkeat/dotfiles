import Quickshell
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData
      color: Theme.background

      // make the bar strip across top of the screen
      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      Workspaces {
        anchors {
          left: parent.left
          top: parent.top
          bottom: parent.bottom
          leftMargin: 8
        }
        screen: modelData // pass the screen of the bar
      }

      Text {
        anchors.centerIn: parent
        color: Theme.text
        text: Time.time
      }
    }
  }
}
