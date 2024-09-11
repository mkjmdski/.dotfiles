import Clutter from "gi://Clutter";
import GObject from "gi://GObject";
import St from "gi://St";
const ROW_HEIGHT = 36;
const MAX_BUTTONS_PER_ROW = 4;
export default GObject.registerClass({
    GTypeName: "GTileOverlayButtonBar"
}, class extends St.Widget {
    #rowHeight;
    static new_themed({ theme, ...params }) {
        return this.new_styled({ ...params, style_class: `${theme}__button-bar` });
    }
    static new_styled(params) {
        return new this(params);
    }
    constructor({ height = ROW_HEIGHT, ...params }) {
        super({
            reactive: true,
            can_focus: true,
            track_hover: true,
            height,
            layout_manager: new Clutter.GridLayout({ column_homogeneous: true }),
            ...params,
        });
        this.#rowHeight = height ?? ROW_HEIGHT;
    }
    set height(height) {
        this.#rowHeight = height;
        const rows = Math.ceil(this.get_n_children() / MAX_BUTTONS_PER_ROW);
        super.height = Math.max(rows, 1) * height;
    }
    addButton(button) {
        const n = this.get_n_children();
        const col = n % MAX_BUTTONS_PER_ROW;
        const row = Math.floor(n / MAX_BUTTONS_PER_ROW);
        this.#layout.attach(button, col, row, 1, 1);
        this.height = this.#rowHeight;
    }
    removeButtons() {
        this.destroy_all_children();
        this.height = this.#rowHeight;
    }
    get #layout() {
        return this.layout_manager;
    }
});
