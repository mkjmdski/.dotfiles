import Clutter from "gi://Clutter";
import GObject from "gi://GObject";
import St from "gi://St";
export default GObject.registerClass({
    GTypeName: "GTileOverlayTitleBar",
    Signals: {
        closed: {},
    }
}, class extends St.Widget {
    #label;
    constructor({ theme, title, ...params }) {
        super({
            style_class: `gtile-testtest`,
            layout_manager: new Clutter.BoxLayout(),
            ...params,
        });
        const closeBtn = new St.Button({
            style_class: [
                `${theme}__close-container`,
                `${theme}__close`,
            ].join(" "),
        });
        this.#label = new St.Label({
            style_class: `${theme}__title`,
            text: title,
        });
        this.add_child(closeBtn);
        this.add_child(this.#label);
        closeBtn.connect("clicked", () => { this.emit("closed"); });
    }
    set title(title) {
        this.#label.text = title;
    }
    get title() {
        return this.#label.text ?? "";
    }
});
