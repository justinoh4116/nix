import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.utils

WrapperMouseArea {
    onClicked: () => {
        NotificationState.notifOverlayOpen = false;
        Config.showSidebar = !Config.showSidebar;
    }

    RowLayout {
        spacing: Config.padding * 2

        Text {
            text: Qt.formatDateTime(Utils.clock.date, "ddd MMM d  hh:mm")
            font.pointSize: Config.textSize + 1
            font.family: "SFPro Nerd Font"
        }

        MaterialIcon {
            text: "notifications" + (NotificationState.allNotifs.length > 0 ? "_unread" : "")
            font.pointSize: Config.iconSize
        }
    }
}
