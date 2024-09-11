import GObject from "gi://GObject";
import St from "gi://St";
import * as PanelMenu from "resource:///org/gnome/shell/ui/panelMenu.js";
export default GObject.registerClass({
    GTypeName: "GTilePanelButton",
}, class extends PanelMenu.Button {
    _init() {
        super._init(.0, "gTile", true);
        const { theme } = arguments[0];
        const icon = new St.Icon({ style_class: "system-status-icon" });
        this.add_child(icon);
        this.add_style_class_name(`${theme}__icon`);
    }
});
