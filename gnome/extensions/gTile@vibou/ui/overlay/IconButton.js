import GObject from "gi://GObject";
import St from "gi://St";
import TextButton from "./TextButton.js";
export default GObject.registerClass({
    GTypeName: "GTileOverlayIconButton",
}, class extends TextButton {
    constructor({ theme, symbol, ...params }) {
        super({
            ...params,
            style_class: `${theme}__action-button`,
            child: new St.BoxLayout({
                style_class: `${theme}__action-button--${symbol}`,
                reactive: true,
                can_focus: true,
                track_hover: true
            }),
        });
    }
});
