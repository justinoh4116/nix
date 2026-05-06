import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.utils

WrapperMouseArea {
    id: root

    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter

    onClicked: () => {
        NotificationState.notifOverlayOpen = false;
        Config.showSidebar = !Config.showSidebar;
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: Config.padding * 2

        Text {
            text: Qt.formatDateTime(Utils.clock.date, "ddd MMM d  hh:mm")
            // font.pointSize: 10.3
            font.pointSize: 10
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
