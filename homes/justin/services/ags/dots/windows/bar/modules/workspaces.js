import { Hyprland, Widget } from "../../../imports.js";
import {
  added,
  changeWorkspace,
  DEFAULT_MONITOR,
  focusedSwitch,
  getLastWorkspaceId,
  moveWorkspace,
  removed,
  workspaceActive,
} from "../../../utils/hyprland.js";

globalThis.hyprland = Hyprland;

const activeId = Hyprland.active.workspace.bind("id")
const workspaces = Hyprland.bind("workspaces")
    .as(ws => (ws.map(({ id }) => Widget.Button({
        on_clicked: () => Hyprland.messageAsync(`dispatch workspace ${id}`),
        child: Widget.Label(`${id}`),
        class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
        attribute: id,
    }))).sort((a, b) => (a.attribute > b.attribute ? 1 : -1)))
    

export default () =>
    Widget.Box({
        class_name: "workspaces",
        children: workspaces,
    })

// export default () =>
//   Widget.EventBox({
//     onScrollUp: () => changeWorkspace("+1"),
//     onScrollDown: () => changeWorkspace("-1"),
//
//     child: Widget.Box({
//       className: "workspaces module",
//
//       // The Hyprland service is ready later than ags is done parsing the config,
//       // so only build the widget when we receive a signal from it.
//       setup: (self) => {
//         const connID = Hyprland.connect("notify::workspaces", () => {
//           Hyprland.disconnect(connID);
//
//           self.children = makeWorkspaces();
//           self.lastFocused = Hyprland.active.workspace.id;
//           self.biggestId = getLastWorkspaceId();
//           self
//             .hook(Hyprland.active.workspace, focusedSwitch)
//             .hook(Hyprland, added, "workspace-added")
//             .hook(Hyprland, removed, "workspace-removed")
//             .hook(Hyprland, (self, name, data) => {
//               if (name === "moveworkspace") moveWorkspace(self, data);
//             }, "event");
//         });
//       },
//     }),
//   });
