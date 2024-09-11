import Clutter from "gi://Clutter";
import GObject from "gi://GObject";
import St from "gi://St";
import TextButton from "./TextButton.js";
export default GObject.registerClass({
    GTypeName: "GTileOverlayGrid",
    Properties: {
        "grid-size": GObject.ParamSpec.jsobject("grid-size", "Grid size", "The dimension of the grid in terms of columns and rows", GObject.ParamFlags.READWRITE),
        selection: GObject.ParamSpec.jsobject("selection", "Selection", "A rectangular tile selection within the grid", GObject.ParamFlags.READWRITE),
        "hover-tile": GObject.ParamSpec.jsobject("hover-tile", "Hover tile", "The currently hovered tile in the grid, if any", GObject.ParamFlags.READABLE),
    },
    Signals: {
        selected: {},
    }
}, class extends St.Widget {
    #theme;
    #gridSize;
    #selection;
    #hoverTile;
    constructor({ theme, gridSize, selection = null, ...params }) {
        super({
            style_class: `${theme}__tile-table`,
            can_focus: true,
            track_hover: true,
            reactive: true,
            layout_manager: new Clutter.GridLayout({
                row_homogeneous: true,
                column_homogeneous: true,
            }),
            ...params
        });
        this.#theme = theme;
        this.gridSize = gridSize;
        this.selection = selection;
        this.#hoverTile = null;
    }
    set gridSize(gridSize) {
        if (this.selection) {
            this.selection = null;
        }
        this.#gridSize = gridSize;
        this.destroy_all_children();
        this.#renderGrid();
        this.notify("grid-size");
    }
    get gridSize() {
        return this.#gridSize;
    }
    set selection(selection) {
        this.#selection = selection;
        this.#refreshGrid();
        this.notify("selection");
    }
    get selection() {
        return this.#selection;
    }
    get hoverTile() {
        return this.#hoverTile;
    }
    get #layoutManager() {
        return this.layout_manager;
    }
    #renderGrid() {
        const tileWidth = this.width / this.gridSize.cols;
        const tileHeight = this.height / this.gridSize.rows;
        for (let col = 0; col < this.gridSize.cols; ++col) {
            for (let row = 0; row < this.gridSize.rows; ++row) {
                const tile = TextButton.new_styled({
                    style_class: `${this.#theme}__tile-table-item`,
                    width: tileWidth,
                    height: tileHeight,
                });
                tile.connect("clicked", this.#onTileClick.bind(this, col, row));
                tile.connect("notify::hover", this.#onTileHover.bind(this, col, row));
                this.#layoutManager.attach(tile, col, row, 1, 1);
            }
        }
    }
    #refreshGrid() {
        const anchor = this.selection?.anchor ?? { col: -1, row: -1 };
        const { col: endCol, row: endRow } = this.selection?.target ?? anchor;
        const { col: startCol, row: startRow } = anchor;
        const colRange = [Math.min(startCol, endCol), Math.max(startCol, endCol)];
        const rowRange = [Math.min(startRow, endRow), Math.max(startRow, endRow)];
        for (let row = 0; row < this.gridSize.rows; ++row) {
            for (let col = 0; col < this.gridSize.cols; ++col) {
                const tile = this.#layoutManager.get_child_at(col, row);
                const isActive = (colRange[0] <= col && col <= colRange[1] &&
                    rowRange[0] <= row && row <= rowRange[1]);
                if (tile.active !== isActive) {
                    tile.active = isActive;
                }
            }
        }
    }
    #onTileClick(col, row) {
        const at = { col, row };
        if (!this.selection) {
            this.selection = { anchor: at, target: at };
            return;
        }
        this.selection = { anchor: this.selection.anchor, target: at };
        this.emit("selected");
        this.selection = null;
    }
    #onTileHover(col, row, tile) {
        if (!this.selection) {
            tile.active = tile.hover;
            const isStale = this.#hoverTile?.col !== col ||
                this.#hoverTile?.row !== row;
            if (tile.hover && isStale) {
                this.#hoverTile = { col, row };
                this.notify("hover-tile");
            }
            else if (!tile.hover && !isStale) {
                this.#hoverTile = null;
                this.notify("hover-tile");
            }
            return;
        }
        if (this.#hoverTile) {
            this.#hoverTile = null;
        }
        if (this.selection.target.col !== col ||
            this.selection.target.row !== row) {
            this.selection = {
                anchor: this.selection.anchor,
                target: { col, row },
            };
        }
    }
});
