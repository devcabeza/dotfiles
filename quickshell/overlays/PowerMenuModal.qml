import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../theme"

PanelWindow {
    id: root

    property bool opened: false

    visible: opened

    WlrLayershell.namespace: "quickshell-power"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    function toggle() {
        if (opened) {
            close();
        } else {
            open();
        }
    }

    function open() {
        opened = true;
        keyHandler.forceActiveFocus();
    }

    function close() {
        opened = false;
    }

    // Telón de fondo semi-transparente para oscurecer y cerrar al hacer clic
    Rectangle {
        id: scrim
        anchors.fill: parent
        color: "#4411111b"
        opacity: root.opened ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 180 } }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.ArrowCursor
            onClicked: root.close()
        }
    }

    // Receptor de teclas globales (Esc, P, R, E, S, L)
    Item {
        id: keyHandler
        focus: true

        Keys.onEscapePressed: root.close()

        Keys.onPressed: event => {
            if (event.key === Qt.Key_P) {
                root.close();
                Quickshell.execDetached(["systemctl", "poweroff"]);
                event.accepted = true;
            } else if (event.key === Qt.Key_R) {
                root.close();
                Quickshell.execDetached(["systemctl", "reboot"]);
                event.accepted = true;
            } else if (event.key === Qt.Key_E) {
                root.close();
                Quickshell.execDetached(["sh", "-c", "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop 2>/dev/null || hyprctl dispatch 'hl.dsp.exit()'"]);
                event.accepted = true;
            } else if (event.key === Qt.Key_S) {
                root.close();
                Quickshell.execDetached(["systemctl", "suspend"]);
                event.accepted = true;
            } else if (event.key === Qt.Key_L) {
                root.close();
                Quickshell.execDetached(["loginctl", "lock-session"]);
                event.accepted = true;
            }
        }
    }

    // Tarjeta del menú flotante posicionada bajo el botón en la esquina superior derecha
    Rectangle {
        id: menuCard
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 48
        anchors.rightMargin: 12

        width: 310
        height: cardColumn.implicitHeight + 28
        radius: 14
        color: Colors.cardBg
        border.color: Colors.cardBorder
        border.width: 1.5

        scale: root.opened ? 1.0 : 0.95
        opacity: root.opened ? 1.0 : 0.0

        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 180 } }

        // Evitar que clics dentro de la tarjeta cierren el menú
        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onClicked: {}
        }

        Column {
            id: cardColumn
            anchors.top: parent.top
            anchors.topMargin: 14
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.right: parent.right
            anchors.rightMargin: 14
            spacing: 10

            // Encabezado del usuario
            Row {
                width: parent.width
                spacing: 10

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: Colors.surface0
                    border.color: Colors.mauve
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        font.pixelSize: 18
                        color: Colors.mauve
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 80
                    spacing: 2

                    Text {
                        text: "alejandrocabeza"
                        font.pixelSize: 13
                        font.bold: true
                        color: Colors.text
                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Text {
                        text: "Hyprland · Arch Linux"
                        font.pixelSize: 11
                        color: Colors.subtext0
                        elide: Text.ElideRight
                        width: parent.width
                    }
                }

                // Botón de cerrar (x)
                Rectangle {
                    width: 28
                    height: 28
                    radius: 14
                    color: closeMouse.containsMouse ? Colors.surface1 : "transparent"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        font.pixelSize: 13
                        color: closeMouse.containsMouse ? Colors.red : Colors.overlay1
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }

            // Separador
            Rectangle {
                width: parent.width
                height: 1
                color: Colors.surface0
            }

            // Lista de Acciones
            Repeater {
                model: [
                    {
                        label: "Apagar",
                        sublabel: "Cerrar sistema y apagar equipo",
                        icon: "⏻",
                        keyHint: "P",
                        accent: Colors.red,
                        action: function() {
                            Quickshell.execDetached(["systemctl", "poweroff"]);
                        }
                    },
                    {
                        label: "Reiniciar",
                        sublabel: "Reiniciar el sistema operativo",
                        icon: "",
                        keyHint: "R",
                        accent: Colors.peach,
                        action: function() {
                            Quickshell.execDetached(["systemctl", "reboot"]);
                        }
                    },
                    {
                        label: "Cerrar sesión",
                        sublabel: "Finalizar la sesión de Hyprland",
                        icon: "󰍃",
                        keyHint: "E",
                        accent: Colors.mauve,
                        action: function() {
                            Quickshell.execDetached(["sh", "-c", "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop 2>/dev/null || hyprctl dispatch 'hl.dsp.exit()'"]);
                        }
                    },
                    {
                        label: "Suspender",
                        sublabel: "Poner el equipo en modo reposo",
                        icon: "󰤄",
                        keyHint: "S",
                        accent: Colors.yellow,
                        action: function() {
                            Quickshell.execDetached(["systemctl", "suspend"]);
                        }
                    },
                    {
                        label: "Bloquear pantalla",
                        sublabel: "Bloquear la sesión con contraseña",
                        icon: "󰌾",
                        keyHint: "L",
                        accent: Colors.blue,
                        action: function() {
                            Quickshell.execDetached(["loginctl", "lock-session"]);
                        }
                    }
                ]

                Rectangle {
                    id: actionBtn
                    width: parent.width
                    height: 44
                    radius: 9
                    color: btnMouse.containsMouse ? Colors.surface0 : "transparent"
                    border.color: btnMouse.containsMouse ? modelData.accent : "transparent"
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 120 } }
                    Behavior on border.color { ColorAnimation { duration: 120 } }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 10

                        // Icon container con tint
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 7
                            color: btnMouse.containsMouse ? modelData.accent : Colors.surface0
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color { ColorAnimation { duration: 120 } }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.icon
                                font.pixelSize: 14
                                color: btnMouse.containsMouse ? Colors.crust : modelData.accent
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }
                        }

                        // Textos
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 80
                            spacing: 1

                            Text {
                                text: modelData.label
                                font.pixelSize: 13
                                font.bold: true
                                color: btnMouse.containsMouse ? modelData.accent : Colors.text
                                elide: Text.ElideRight
                                width: parent.width
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }

                            Text {
                                text: modelData.sublabel
                                font.pixelSize: 10
                                color: Colors.subtext0
                                elide: Text.ElideRight
                                width: parent.width
                            }
                        }

                        // Badge del atajo de teclado
                        Rectangle {
                            width: 22
                            height: 20
                            radius: 4
                            color: Colors.surface0
                            border.color: Colors.surface1
                            border.width: 1
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: modelData.keyHint
                                font.pixelSize: 10
                                font.bold: true
                                color: Colors.overlay1
                            }
                        }
                    }

                    MouseArea {
                        id: btnMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.close();
                            modelData.action();
                        }
                    }
                }
            }
        }
    }
}
