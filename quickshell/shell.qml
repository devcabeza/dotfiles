import QtQuick
import Quickshell
import Quickshell.Io
import "components"
import "overlays"

ShellRoot {
    id: root

    // Controladores IPC para llamadas desde atajos de Hyprland
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            launcherModal.toggle();
        }
    }

    IpcHandler {
        target: "power"
        function toggle(): void {
            powerModal.toggle();
        }
    }

    IpcHandler {
        target: "controlcenter"
        function toggle(): void {
            controlCenterModal.toggle();
        }
    }

    IpcHandler {
        target: "media"
        function toggle(): void {
            mediaModal.toggle();
        }
    }

    // Modales y Overlays
    AppLauncher {
        id: launcherModal
    }

    PowerMenuModal {
        id: powerModal
    }

    ControlCenterModal {
        id: controlCenterModal
    }

    MediaFlyout {
        id: mediaModal
    }

    PolkitModal {
        id: polkitModal
    }

    VolumeOSD {
        id: osdModal
    }

    // Barra superior instanciada en cada monitor conectado
    Variants {
        model: Quickshell.screens

        Bar {
            property var modelData
            screen: modelData
            onOpenLauncher: launcherModal.toggle()
            onOpenPowerMenu: powerModal.toggle()
            onOpenControlCenter: controlCenterModal.toggle()
            onOpenMedia: mediaModal.toggle()
        }
    }
}
