import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../theme"

Row {
    id: root
    spacing: 4

    Repeater {
        model: SystemTray.items

        Rectangle {
            id: trayItemRect
            width: 26
            height: 26
            radius: 7
            color: mouseArea.containsMouse ? Colors.surface1 : "transparent"
            border.color: mouseArea.containsMouse ? Colors.surface2 : "transparent"
            border.width: 1

            Behavior on color { ColorAnimation { duration: 120 } }
            Behavior on border.color { ColorAnimation { duration: 120 } }

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: (modelData && modelData.icon) ? modelData.icon : ""
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate();
                    } else if (mouse.button === Qt.RightButton) {
                        if (modelData.secondaryActivate) {
                            modelData.secondaryActivate();
                        } else {
                            modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
