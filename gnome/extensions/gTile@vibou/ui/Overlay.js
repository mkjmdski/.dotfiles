import GObject from "gi://GObject";
import St from "gi://St";
import ButtonBar from "./overlay/ButtonBar.js";
import Container from "./overlay/Container.js";
import Grid from "./overlay/Grid.js";
import TextButton from "./overlay/TextButton.js";
import TitleBar from "./overlay/TitleBar.js";
const TABLE_WIDTH = 320;
export default GObject.registerClass({
    GTypeName: "GTileOverlay",
    Properties: {
        animate: GObject.ParamSpec.boolean("animate", "Animate", "Whether to anmiate UI position changes", GObject.ParamFlags.READWRITE, true),
        "grid-size": GObject.ParamSpec.jsobject("grid-size", "Grid size", "The dimension of the grid in terms of columns and rows", GObject.ParamFlags.READWRITE),
        "grid-selection": GObject.ParamSpec.jsobject("grid-selection", "Grid selection", "A rectangular tile selection within the grid", GObject.ParamFlags.READWRITE),
        "grid-hover-tile": GObject.ParamSpec.jsobject("grid-hover-tile", "Grid hover tile", "The currently hovered tile in the grid, if any", GObject.ParamFlags.READABLE),
        "selection-timeout": GObject.ParamSpec.int("selection-timeout", "Selection timeout", "Grace period before a selection is unset when the cursor loses focus.", GObject.ParamFlags.READWRITE, 0, 5000, 200)
    },
    Signals: {
        selected: {},
    }
}, class extends St.BoxLayout {
    #theme;
    #titleBar;
    #grid;
    #presetButtons;
    #actionButtons;
    #animate;
    #selectionTimeout;
    #delayTimeoutID = null;
    constructor({ theme, title, presets, gridAspectRatio, gridSelection = null, animate = true, selectionTimeout = 200, ...params }) {
        super({
            style_class: theme,
            vertical: true,
            reactive: true,
            can_focus: true,
            track_hover: true,
            ...params,
        });
        this.#theme = theme;
        this.#titleBar = new TitleBar({ theme, title });
        this.#grid = new Grid({
            theme,
            gridSize: presets[0],
            selection: gridSelection,
            width: TABLE_WIDTH - 2,
            height: TABLE_WIDTH / gridAspectRatio,
        });
        this.#presetButtons = ButtonBar.new_styled({
            style_class: `${theme}__preset`,
            width: TABLE_WIDTH - 20,
        });
        this.#actionButtons = ButtonBar.new_styled({
            style_class: `${theme}__action`,
            width: TABLE_WIDTH - 20,
        });
        this.#animate = animate;
        this.#selectionTimeout = selectionTimeout;
        this.#delayTimeoutID = null;
        this.presets = presets;
        this.add_child(Container.new_styled({
            style_class: `${theme}__title-container`,
            child: this.#titleBar,
        }));
        this.add_child(Container.new_styled({
            style_class: `${theme}__tile-container`,
            child: this.#grid
        }));
        this.add_child(Container.new_styled({
            style_class: `${theme}__preset-container`,
            child: this.#presetButtons
        }));
        this.add_child(Container.new_styled({
            style_class: `${theme}__action-container`,
            child: this.#actionButtons
        }));
        this.#titleBar.connect("closed", () => { this.visible = false; });
        this.#grid.connect("notify::grid-size", () => {
            this.#onGridSizeChanged();
            this.notify("grid-size");
        });
        this.#grid.connect("notify::selection", () => this.notify("grid-selection"));
        this.#grid.connect("notify::hover-tile", () => this.notify("grid-hover-tile"));
        this.#grid.connect("selected", () => this.emit("selected"));
        this.connect("notify::visible", () => { this.gridSelection = null; });
        this.connect("notify::hover", this.#onHoverChanged.bind(this));
    }
    release() {
        if (this.#delayTimeoutID) {
            clearTimeout(this.#delayTimeoutID);
            this.#delayTimeoutID = null;
        }
    }
    set title(title) {
        this.#titleBar.title = title;
    }
    get title() {
        return this.#titleBar.title;
    }
    set gridSize(gridSize) {
        this.#grid.gridSize = gridSize;
    }
    get gridSize() {
        return this.#grid.gridSize;
    }
    set gridSelection(gridSelection) {
        this.#grid.selection = gridSelection;
    }
    get gridSelection() {
        return this.#grid.selection;
    }
    set animate(animate) {
        this.#animate = animate;
    }
    get animate() {
        return this.#animate;
    }
    set selectionTimeout(timeout) {
        this.#selectionTimeout = timeout;
        this.notify("selection-timeout");
    }
    get selectionTimeout() {
        return this.#selectionTimeout;
    }
    get gridHoverTile() {
        return this.#grid.hoverTile;
    }
    get popupOffsetX() {
        return -(this.width / 2);
    }
    get popupOffsetY() {
        return -(this.#titleBar.get_parent().height / 2);
    }
    set presets(presets) {
        this.#presetButtons.removeButtons();
        const { cols, rows } = this.gridSize;
        for (const preset of presets) {
            const isPresetActive = preset.cols === cols && preset.rows === rows;
            const button = TextButton.new_themed({
                theme: this.#theme,
                active: isPresetActive,
                label: `${preset.cols}x${preset.rows}`,
            });
            this.#presetButtons.addButton(button);
            button.connect("clicked", () => { this.#grid.gridSize = preset; });
        }
    }
    placeAt(x, y) {
        this.animate && this.save_easing_state();
        this.x = x;
        this.y = y;
        this.animate && this.restore_easing_state();
    }
    iteratePreset() {
        const textButtons = this.#presetButtons.get_children();
        const { cols: currentCols, rows: currentRows } = this.gridSize;
        let activateNext = false;
        for (const button of [...textButtons, textButtons[0]]) {
            const [cols, rows] = button.label.split("x").map(n => Number(n));
            if (activateNext) {
                this.gridSize = { cols, rows };
                return;
            }
            else if (cols === currentCols && rows === currentRows) {
                activateNext = true;
            }
        }
    }
    addActionButton(button) {
        this.#actionButtons.addButton(button);
    }
    #onGridSizeChanged() {
        const textButtons = this.#presetButtons.get_children();
        const { cols, rows } = this.gridSize;
        for (const button of textButtons) {
            button.active = button.label === `${cols}x${rows}`;
        }
    }
    #onHoverChanged() {
        if (this.#delayTimeoutID) {
            clearTimeout(this.#delayTimeoutID);
            this.#delayTimeoutID = null;
        }
        if (!this.hover && this.#grid.selection) {
            this.#delayTimeoutID = setTimeout(() => {
                this.#grid.selection = null;
            }, this.#selectionTimeout);
        }
    }
});
