import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../theme"

Row {
    id: root
    spacing: 3

    Repeater {
        model: SystemTray.items

        Rectangle {
            id: trayItemRect
            width: 22
            height: 22
            radius: 6
            color: mouseArea.containsMouse ? Colors.surface1 : "transparent"

            Behavior on color { ColorAnimation { duration: 120 } }

            Image {
                anchors.centerIn: parent
                width: 15
                height: 15
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
