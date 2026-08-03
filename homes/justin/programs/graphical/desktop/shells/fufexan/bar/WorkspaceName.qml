import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.utils

Item {
    id: root

    property string workspaceName: ""
    property string focusedWindowName: ""
    property string timeStatus: "stopped"
    property string timeSpent: ""
    readonly property int maxWindowNameLength: 60

    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: workspaceLabel.implicitWidth

    Text {
        id: workspaceLabel

        anchors.centerIn: parent

        text: root.formattedLabel()
        font.pointSize: 11
        font.family: "SF Pro"
        font.styleName: "Medium"
        color: Colors.foreground
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    function refreshWorkspace() {
        if (!workspaceProcess.running)
            workspaceProcess.running = true;
    }

    function refreshTimeStatus() {
        if (!timeStatusFileProcess.running)
            timeStatusFileProcess.running = true;
    }

    function refreshFocusedWindow() {
        if (!focusedWindowProcess.running)
            focusedWindowProcess.running = true;
    }

    function refreshElapsedTime() {
        if (root.isStoppedStatus()) {
            root.timeSpent = "";
            return;
        }

        if (!elapsedTimeProcess.running)
            elapsedTimeProcess.running = true;
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

    function isStoppedStatus() {
        const status = (root.timeStatus || "").trim().toLowerCase();
        return !status || status === "stop" || status === "stopped";
    }

    function truncateWindowName(name) {
        if (name.length <= root.maxWindowNameLength)
            return name;

        return name.slice(0, root.maxWindowNameLength - 1) + "…";
    }

    function formattedLabel() {
        const workspace = (root.workspaceName || "").trim();
        const windowName = (root.focusedWindowName || "").trim();
        const status = (root.timeStatus || "").trim();
        const timeSpent = (root.timeSpent || "").trim();
        const location = workspace && windowName
            ? workspace + ": " + windowName
            : workspace || windowName;

        if (location && status && timeSpent)
            return location + " | " + status + ": " + timeSpent;

        if (location && status)
            return location + " | " + status;

        return location || status;
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

    Process {
        id: timeStatusFileProcess
        command: ["sh", "-c", "cat \"$HOME/.time\" 2>/dev/null || printf 'stopped\\n'"]
        stdout: SplitParser {
            onRead: data => {
                const nextStatus = String(data || "").trim() || "stopped";
                const previousStatus = root.timeStatus;

                root.timeStatus = nextStatus;

                if (root.isStoppedStatus()) {
                    root.timeSpent = "";
                } else if (nextStatus !== previousStatus) {
                    root.refreshElapsedTime();
                }
            }
        }
    }

    Process {
        id: focusedWindowProcess
        command: ["sh", "-c", "niri msg -j focused-window 2>/dev/null || printf 'null'"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                try {
                    const window = JSON.parse(text || "null");
                    root.focusedWindowName = root.truncateWindowName(String(window?.title || ""));
                } catch (error) {
                    root.focusedWindowName = "";
                }
            }
        }
    }

    Process {
        id: elapsedTimeProcess
        command: ["sh", "-c", "timew 2>/dev/null | awk '/^ *Total/ {print $NF}'"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                root.timeSpent = (text || "").trim();
            }
        }
    }

    Timer {
        id: workspaceTimer
        interval: 500
        running: true
        repeat: true
        onTriggered: root.refreshWorkspace()
    }

    Timer {
        id: timeStatusTimer
        interval: 500
        running: true
        repeat: true
        onTriggered: root.refreshTimeStatus()
    }

    Timer {
        id: focusedWindowTimer
        interval: 500
        running: true
        repeat: true
        onTriggered: root.refreshFocusedWindow()
    }

    Timer {
        id: elapsedTimeTimer
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.refreshElapsedTime()
    }

    Component.onCompleted: {
        root.refreshWorkspace();
        root.refreshFocusedWindow();
        root.refreshTimeStatus();
        root.refreshElapsedTime();
    }
}
