import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../theme"

PanelWindow {
    id: root

    property bool opened: false
    property var allApps: []
    property var filteredApps: []
    property int selectedIndex: 0

    visible: opened

    WlrLayershell.namespace: "quickshell-launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    color: "transparent"

    function refreshApps() {
        if (!DesktopEntries.applications) return;
        let apps = [];
        let vals = DesktopEntries.applications.values;
        for (let i = 0; i < vals.length; ++i) {
            let entry = vals[i];
            if (entry && entry.name && !entry.noDisplay) {
                apps.push(entry);
            }
        }
        apps.sort((a, b) => a.name.localeCompare(b.name));
        allApps = apps;
        filterApps();
    }

    function filterApps() {
        let query = searchInput.text.toLowerCase().trim();
        if (query === "") {
            filteredApps = allApps;
        } else {
            filteredApps = allApps.filter(entry => {
                let nameMatches = entry.name && entry.name.toLowerCase().includes(query);
                let commentMatches = entry.comment && entry.comment.toLowerCase().includes(query);
                return nameMatches || commentMatches;
            });
        }
        selectedIndex = 0;
        if (appList.count > 0) {
            appList.positionViewAtIndex(0, ListView.Beginning);
        }
    }

    function toggle() {
        if (opened) {
            close();
        } else {
            open();
        }
    }

    function open() {
        opened = true;
        refreshApps();
        searchInput.text = "";
        searchInput.forceActiveFocus();
    }

    function close() {
        opened = false;
        searchInput.text = "";
    }

    function executeSelected() {
        if (filteredApps && selectedIndex >= 0 && selectedIndex < filteredApps.length) {
            let app = filteredApps[selectedIndex];
            app.execute();
            close();
        }
    }

    // Telón de fondo semi-transparente para cerrar al hacer clic afuera
    Rectangle {
        id: scrim
        anchors.fill: parent
        color: "#4411111b"
        opacity: root.opened ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.ArrowCursor
            onClicked: root.close()
        }
    }

    // Modal principal centrado
    Rectangle {
        id: modalContent
        anchors.centerIn: parent
        width: 600
        height: 460
        radius: 14
        color: Colors.cardBg
        border.color: Colors.cardBorder
        border.width: 1.5

        scale: root.opened ? 1.0 : 0.95
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onClicked: {}
        }

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Barra de búsqueda
            Rectangle {
                width: parent.width
                height: 44
                radius: 10
                color: Colors.surface0
                border.color: searchInput.activeFocus ? Colors.mauve : Colors.surface1
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text {
                        text: "󰍉"
                        font.pixelSize: 16
                        color: Colors.mauve
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextInput {
                        id: searchInput
                        width: parent.width - 40
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 14
                        color: Colors.text
                        clip: true

                        Text {
                            text: "Buscar aplicaciones..."
                            color: Colors.overlay0
                            font.pixelSize: 14
                            visible: !searchInput.text && !searchInput.activeFocus
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        onTextChanged: root.filterApps()

                        Keys.onDownPressed: {
                            if (root.filteredApps.length > 0) {
                                root.selectedIndex = Math.min(root.selectedIndex + 1, root.filteredApps.length - 1);
                                appList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                        }

                        Keys.onUpPressed: {
                            if (root.filteredApps.length > 0) {
                                root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                                appList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                        }

                        Keys.onReturnPressed: root.executeSelected()
                        Keys.onEnterPressed: root.executeSelected()
                        Keys.onEscapePressed: root.close()
                    }
                }
            }

            // Separador
            Rectangle {
                width: parent.width
                height: 1
                color: Colors.surface0
            }

            // Lista de aplicaciones
            ListView {
                id: appList
                width: parent.width
                height: parent.height - 72
                clip: true
                model: root.filteredApps
                spacing: 4

                delegate: Rectangle {
                    id: appDelegate
                    width: appList.width
                    height: 48
                    radius: 8
                    color: index === root.selectedIndex ? Colors.surface1 : (delegateMouse.containsMouse ? Colors.surface0 : "transparent")
                    border.color: index === root.selectedIndex ? Colors.mauve : "transparent"
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 100 } }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        Image {
                            id: appIcon
                            width: 28
                            height: 28
                            anchors.verticalCenter: parent.verticalCenter
                            source: Quickshell.iconPath(modelData.icon || "")
                            fillMode: Image.PreserveAspectFit

                            Text {
                                anchors.centerIn: parent
                                visible: appIcon.status !== Image.Ready
                                text: "󰀻"
                                font.pixelSize: 20
                                color: Colors.blue
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 50
                            spacing: 2

                            Text {
                                text: modelData.name || ""
                                font.pixelSize: 13
                                font.bold: true
                                color: index === root.selectedIndex ? Colors.mauve : Colors.text
                                elide: Text.ElideRight
                                width: parent.width
                            }

                            Text {
                                text: modelData.comment || ""
                                font.pixelSize: 11
                                color: Colors.subtext0
                                elide: Text.ElideRight
                                width: parent.width
                                visible: text.length > 0
                            }
                        }
                    }

                    MouseArea {
                        id: delegateMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: root.selectedIndex = index
                        onClicked: {
                            root.selectedIndex = index;
                            root.executeSelected();
                        }
                    }
                }
            }
        }
    }
}
