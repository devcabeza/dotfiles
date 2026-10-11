import QtQuick
import Quickshell
import Quickshell.Wayland
import "../theme"

PanelWindow {
    id: barWindow

    signal openLauncher()
    signal openPowerMenu()

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 6
        left: 10
        right: 10
    }

    implicitHeight: 38
    exclusiveZone: 44
    color: "transparent"

    WlrLayershell.namespace: "quickshell-bar"
    WlrLayershell.layer: WlrLayer.Top

    Rectangle {
        id: barBackground
        anchors.fill: parent
        radius: 12
        color: Colors.barBg
        border.color: Colors.barBorder
        border.width: 1

        // Sección Izquierda
        Row {
            id: leftSection
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            LauncherButton {
                id: launcherBtn
                onClicked: barWindow.openLauncher()
            }

            Workspaces {
                anchors.verticalCenter: parent.verticalCenter
            }

            ActiveWindow {
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Sección Central
        Clock {
            anchors.centerIn: parent
        }

        // Sección Derecha
        Row {
            id: rightSection
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            BtopButton {
                anchors.verticalCenter: parent.verticalCenter
            }

            AudioWidget {
                anchors.verticalCenter: parent.verticalCenter
            }

            BatteryWidget {
                anchors.verticalCenter: parent.verticalCenter
            }

            NetworkWidget {
                anchors.verticalCenter: parent.verticalCenter
            }

            SysTray {
                anchors.verticalCenter: parent.verticalCenter
            }

            PowerMenu {
                anchors.verticalCenter: parent.verticalCenter
                onOpenPowerMenu: barWindow.openPowerMenu()
            }
        }
    }
}
