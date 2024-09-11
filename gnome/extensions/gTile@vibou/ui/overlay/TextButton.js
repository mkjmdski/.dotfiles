import GObject from "gi://GObject";
import St from "gi://St";
export default GObject.registerClass({
    GTypeName: "GTileOverlayTextButton",
    Properties: {
        "active": GObject.ParamSpec.boolean("active", "Active", "Whether the button state is active", GObject.ParamFlags.READWRITE, false),
    }
}, class extends St.Button {
    #active;
    static new_themed({ theme, ...params }) {
        return this.new_styled({
            ...params,
            style_class: `${theme}__preset-button`,
        });
    }
    static new_styled(params) {
        return new this(params);
    }
    constructor({ active = false, ...params }) {
        super({
            reactive: true,
            can_focus: true,
            track_hover: true,
            ...params,
        });
        this.active = active;
    }
    set active(b) {
        this.#active = b;
        this.#updateState();
        this.notify("active");
    }
    get active() {
        return this.#active;
    }
    #updateState() {
        if (this.#active) {
            this.add_style_pseudo_class("activate");
        }
        else {
            this.remove_style_pseudo_class("activate");
        }
    }
});
