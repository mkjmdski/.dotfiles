import GObject from "gi://GObject";
import St from "gi://St";
export default GObject.registerClass({
    GTypeName: "GTileOverlayContainer"
}, class extends St.Bin {
    static new_themed({ theme, ...params }) {
        return this.new_styled({
            ...params,
            style_class: `${theme}__container`,
        });
    }
    static new_styled(params) {
        return new this(params);
    }
    constructor(params) {
        super({
            reactive: true,
            can_focus: true,
            track_hover: true,
            ...params
        });
    }
});
