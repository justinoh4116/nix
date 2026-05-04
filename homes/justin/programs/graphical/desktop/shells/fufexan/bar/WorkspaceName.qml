import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.utils

Text {
    id: root

    property string workspaceName: ""

    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter

    text: workspaceName
    font.pointSize: 11
    font.family: "SF Pro"
    font.styleName: "Medium"
    color: Colors.foreground
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight

    function refreshWorkspaceName() {
        if (!workspaceProcess.running)
            workspaceProcess.running = true;
    }

    function workspaceLabel(workspace) {
        if (!workspace)
            return "";

        if (workspace.name !== undefined && workspace.name !== null && workspace.name !== "")
            return String(workspace.name);

        if (workspace.idx !== undefined && workspace.idx !== null)
            return String(workspace.idx);

        if (workspace.id !== undefined && workspace.id !== null)
            return String(workspace.id);

        return "";
    }

    Process {
        id: workspaceProcess
        command: ["sh", "-c", "niri msg -j workspaces 2>/dev/null || printf '[]'"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                let workspaces = [];

                try {
                    workspaces = JSON.parse(text || "[]");
                } catch (error) {
                    workspaces = [];
                }

                root.workspaceName = root.workspaceLabel(workspaces.find(workspace => workspace?.is_focused))
                    || root.workspaceLabel(workspaces.find(workspace => workspace?.is_active));
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: root.refreshWorkspaceName()
    }

    Component.onCompleted: root.refreshWorkspaceName()
}
