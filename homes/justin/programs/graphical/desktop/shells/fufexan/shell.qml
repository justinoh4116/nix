//@ pragma UseQApplication
//@ pragma DropExpensiveFonts
import qs.bar
import qs.notifications
import qs.osd
import qs.sidebar
import Quickshell // for ShellRoot and PanelWindow

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            barScreen: modelData
        }
    }

    NotificationOverlay {}
    OSD {}
    Sidebar {}
}
