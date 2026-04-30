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
            font.pointSize: 10.3
            font.family: "SF Pro"
            // font.weight: Font.
            font.styleName: "Medium"
        }

        MaterialIcon {
            text: "notifications" + (NotificationState.allNotifs.length > 0 ? "_unread" : "")
            font.pointSize: Config.iconSize
        }
    }
}
