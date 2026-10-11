import QtQuick
import Quickshell
import Quickshell.Wayland
import "../theme"

PanelWindow {
    id: barWindow

    signal openLauncher()
    signal openPowerMenu()
    signal openControlCenter()
    signal openMedia()

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 6
        left: 12
        right: 12
    }

    implicitHeight: 38
    exclusiveZone: 44
    color: "transparent"

    WlrLayershell.namespace: "quickshell-bar"
    WlrLayershell.layer: WlrLayer.Top

    Item {
        anchors.fill: parent

        // ==========================================
        // ISLA IZQUIERDA: Launcher + Workspaces + Ventana / Música
        // ==========================================
        Rectangle {
            id: leftIsland
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 34
            width: leftRow.implicitWidth + 14
            radius: 11
            color: Colors.barBg
            border.color: Colors.barBorder
            border.width: 1

            Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            Row {
                id: leftRow
                anchors.centerIn: parent
                spacing: 6

                LauncherButton {
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: barWindow.openLauncher()
                }

                Workspaces {
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Separador sutil
                Rectangle {
                    width: 1
                    height: 14
                    color: Colors.surface1
                    anchors.verticalCenter: parent.verticalCenter
                }

                ActiveWindow {
                    anchors.verticalCenter: parent.verticalCenter
                }

                MediaWidget {
                    anchors.verticalCenter: parent.verticalCenter
                    onOpenFlyout: barWindow.openMedia()
                }
            }
        }

        // ==========================================
        // ISLA CENTRAL: Reloj y Calendario
        // ==========================================
        Rectangle {
            id: centerIsland
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 34
            width: centerRow.implicitWidth + 16
            radius: 11
            color: Colors.barBg
            border.color: Colors.barBorder
            border.width: 1

            Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            Row {
                id: centerRow
                anchors.centerIn: parent

                Clock {
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // ==========================================
        // ISLA DERECHA: Rendimiento + Sistema + Controles + Apagado
        // ==========================================
        Rectangle {
            id: rightIsland
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 34
            width: rightRow.implicitWidth + 14
            radius: 11
            color: Colors.barBg
            border.color: Colors.barBorder
            border.width: 1

            Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            Row {
                id: rightRow
                anchors.centerIn: parent
                spacing: 6

                SysStatsWidget {
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Separador
                Rectangle {
                    width: 1
                    height: 14
                    color: Colors.surface1
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

                // Separador
                Rectangle {
                    width: 1
                    height: 14
                    color: Colors.surface1
                    anchors.verticalCenter: parent.verticalCenter
                }

                CaffeineWidget {
                    targetWindow: barWindow
                    anchors.verticalCenter: parent.verticalCenter
                }

                SysTray {
                    anchors.verticalCenter: parent.verticalCenter
                }

                ControlCenterButton {
                    anchors.verticalCenter: parent.verticalCenter
                    onOpenControlCenter: barWindow.openControlCenter()
                }

                PowerMenu {
                    anchors.verticalCenter: parent.verticalCenter
                    onOpenPowerMenu: barWindow.openPowerMenu()
                }
            }
        }
    }
}
