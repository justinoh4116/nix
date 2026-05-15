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

        WrapperMouseArea {
            acceptedButtons: Qt.RightButton
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: notificationIcon.implicitWidth
            implicitHeight: notificationIcon.implicitHeight

            onClicked: event => {
                event.accepted = true;
                DndState.toggle();
            }

            MaterialIcon {
                id: notificationIcon

                anchors.centerIn: parent
                anchors.verticalCenterOffset: -.5
                text: DndState.enabled ? "notifications_off" : "notifications" + (NotificationState.allNotifs.length > 0 ? "_unread" : "")
                font.pointSize: Config.iconSize
            }
        }
    }
}
