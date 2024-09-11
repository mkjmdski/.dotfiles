import GObject from "gi://GObject";
import St from "gi://St";
export default GObject.registerClass({
    GTypeName: "GTilePreview",
    Properties: {
        animate: GObject.ParamSpec.boolean("animate", "Animate", "Whether to anmiate preview changes", GObject.ParamFlags.READWRITE, true),
    }
}, class extends St.BoxLayout {
    #animate;
    constructor({ theme, animate = true, ...params }) {
        super({
            style_class: `${theme}__preview`,
            visible: false,
            ...params,
        });
        this.#animate = animate;
        this.add_style_pseudo_class("activate");
    }
    set animate(animate) {
        this.#animate = animate;
    }
    get animate() {
        return this.#animate;
    }
    set previewArea(area) {
        this.visible = !!area;
        if (area) {
            this.animate && this.save_easing_state();
            this.x = area.x;
            this.y = area.y;
            this.width = area.width;
            this.height = area.height;
            this.animate && this.restore_easing_state();
        }
    }
});
