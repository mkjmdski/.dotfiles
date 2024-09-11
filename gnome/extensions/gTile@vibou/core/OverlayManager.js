import Gio from "gi://Gio";
import Meta from "gi://Meta";
import St from "gi://St";
import Overlay from "../ui/Overlay.js";
import IconButton from "../ui/overlay/IconButton.js";
import Preview from "../ui/Preview.js";
import { GarbageCollection } from "../util/gc.js";
export default class {
    #theme;
    #settings;
    #gnomeSettings;
    #presets;
    #layoutManager;
    #desktopManager;
    #gridLineOverlayGc;
    #windowSubscriptionGc;
    #dispatchCallbacks;
    #overlays;
    #preview;
    #activeIdx;
    #syncInProgress;
    constructor({ theme, settings, gnomeSettings, presets, layoutManager, desktopManager, }) {
        this.#theme = theme;
        this.#settings = settings;
        this.#gnomeSettings = gnomeSettings;
        this.#presets = presets;
        this.#layoutManager = layoutManager;
        this.#desktopManager = desktopManager;
        this.#gridLineOverlayGc = new GarbageCollection();
        this.#windowSubscriptionGc = new GarbageCollection();
        this.#dispatchCallbacks = [];
        this.#overlays = [];
        this.#preview = new Preview({ theme: this.#theme });
        this.#activeIdx = null;
        this.#syncInProgress = false;
        desktopManager.subscribe(this.#onDesktopEvent.bind(this));
        gnomeSettings.bind("enable-animations", this.#preview, "animate", Gio.SettingsBindFlags.GET);
        layoutManager.addTopChrome(this.#preview);
        this.#renderOverlays();
    }
    release() {
        this.#gridLineOverlayGc.release();
        this.#windowSubscriptionGc.release();
        this.#preview.destroy();
        this.#destroyOverlays();
        this.#dispatchCallbacks = [];
    }
    set presets(presets) {
        this.#presets = presets;
        for (const overlay of this.#overlays) {
            overlay.presets = presets;
        }
    }
    get presets() {
        return this.#presets;
    }
    get gridSize() {
        return this.#overlays[0].gridSize;
    }
    get activeMonitor() {
        return this.#activeIdx;
    }
    subscribe(fn) {
        this.#dispatchCallbacks.push(fn);
    }
    toggleOverlays(hide) {
        const visible = hide ?? this.#overlays.some(({ visible }) => visible);
        if (visible) {
            this.#syncInProgress = true;
            this.#overlays.forEach(overlay => overlay.hide());
            this.#syncInProgress = false;
            this.#dispatch({ type: 3, visible: false });
            return;
        }
        const window = this.#desktopManager.focusedWindow;
        if (!window ||
            window.get_window_type() === Meta.WindowType.DESKTOP ||
            window.get_layer().valueOf() === Meta.StackLayer.DESKTOP ||
            this.#overlays.length === 0) {
            return;
        }
        if (this.#settings.get_boolean("follow-cursor")) {
            this.#placeOverlays();
        }
        else {
            this.#placeOverlays(window);
        }
        this.#syncInProgress = true;
        this.#overlays.forEach(overlay => overlay.show());
        this.#syncInProgress = false;
        this.#dispatch({ type: 3, visible: true });
    }
    setSelection(selection, monitorIdx) {
        this.#overlays[monitorIdx].gridSelection = selection;
    }
    getSelection(monitorIdx) {
        return this.#overlays[monitorIdx].gridSelection;
    }
    iteratePreset() {
        this.#syncInProgress = true;
        this.#overlays.forEach(overlay => overlay.iteratePreset());
        this.#syncInProgress = false;
        this.#renderGridPreview(this.#overlays[0].gridSize);
    }
    #dispatch(event) {
        for (const cb of this.#dispatchCallbacks) {
            cb(event);
        }
    }
    #renderOverlays() {
        for (const monitor of this.#desktopManager.monitors) {
            const overlay = new Overlay({
                theme: this.#theme,
                title: "gTile",
                presets: this.#presets,
                gridAspectRatio: monitor.workArea.width / monitor.workArea.height,
                visible: false,
            });
            this.#gnomeSettings.bind("enable-animations", overlay, "animate", Gio.SettingsBindFlags.GET);
            for (const key of ["auto-close", "follow-cursor"]) {
                const btn = new IconButton({
                    theme: this.#theme,
                    symbol: key,
                    active: this.#settings.get_boolean(key),
                    can_focus: false,
                    track_hover: false,
                });
                this.#settings.bind(key, btn, "active", Gio.SettingsBindFlags.DEFAULT);
                btn.connect("clicked", () => { btn.active = !btn.active; });
                overlay.addActionButton(btn);
            }
            for (const symbol of ["main-and-list", "two-list"]) {
                const button = new IconButton({ theme: this.#theme, symbol });
                overlay.addActionButton(button);
                const layout = symbol === "two-list" ? "main-inverted" : "main";
                button.connect("clicked", () => {
                    this.#dispatch({ type: 2, layout });
                });
            }
            this.#settings.bind("selection-timeout", overlay, "selection-timeout", Gio.SettingsBindFlags.GET);
            overlay.connect("notify::visible", this.#onGridVisibleChanged.bind(this));
            overlay.connect("notify::grid-size", this.#onGridSizeChanged.bind(this));
            overlay.connect("notify::grid-selection", this.#onGridSelectionChanged.bind(this));
            overlay.connect("notify::grid-hover-tile", this.#onGridHoverTileChanged.bind(this));
            overlay.connect("selected", () => this.#dispatch({
                type: 1,
                monitorIdx: monitor.index,
                gridSize: overlay.gridSize,
                selection: overlay.gridSelection,
            }));
            this.#layoutManager.addChrome(overlay);
            this.#overlays.push(overlay);
        }
    }
    #destroyOverlays() {
        let overlay, wasVisible = false;
        while (overlay = this.#overlays.pop()) {
            wasVisible ||= overlay.visible;
            overlay.release();
            overlay.destroy();
        }
        if (wasVisible) {
            this.#dispatch({ type: 3, visible: false });
        }
    }
    #renderGridPreview(gridSize, timeout = 1000) {
        if (!this.#settings.get_boolean("show-grid-lines")) {
            return;
        }
        this.#gridLineOverlayGc.release();
        for (const { workArea } of this.#desktopManager.monitors) {
            const tileWidth = workArea.width / gridSize.cols;
            const tileHeight = workArea.height / gridSize.rows;
            for (let i = 1; i < gridSize.cols; ++i) {
                const gridLine = new St.BoxLayout({
                    style_class: `${this.#theme}__grid_lines_preview`,
                    x: workArea.x + tileWidth * i,
                    y: workArea.y,
                    width: 1,
                    height: workArea.height,
                });
                this.#gridLineOverlayGc.defer(() => gridLine.destroy());
                this.#layoutManager.addChrome(gridLine);
            }
            for (let i = 1; i < gridSize.rows; ++i) {
                const gridLine = new St.BoxLayout({
                    style_class: `${this.#theme}__grid_lines_preview`,
                    x: workArea.x,
                    y: workArea.y + tileHeight * i,
                    width: workArea.width,
                    height: 1,
                });
                this.#gridLineOverlayGc.defer(() => gridLine.destroy());
                this.#layoutManager.addChrome(gridLine);
            }
        }
        const id = setTimeout(() => this.#gridLineOverlayGc.release(), timeout);
        this.#gridLineOverlayGc.defer(() => clearTimeout(id));
    }
    #updateTitle(title) {
        for (const overlay of this.#overlays) {
            overlay.title = title;
        }
        ;
    }
    #syncTitleWithWindow(window) {
        this.#windowSubscriptionGc.release();
        if (window) {
            this.#updateTitle(window.title ?? "gTile");
            const chid = window.connect("notify::title", () => {
                this.#updateTitle(window.title ?? "gTile");
            });
            this.#windowSubscriptionGc.defer(() => {
                window.disconnect(chid);
            });
        }
    }
    #placeOverlays(focusedWindow) {
        const monitors = this.#desktopManager.monitors;
        console.assert(monitors.length === this.#overlays.length, `gTile: number of overlays (${this.#overlays.length}) do not match the` +
            `number of monitors(${monitors.length})`);
        console.assert(Math.max(...monitors.map(m => m.index)) === this.#overlays.length - 1, `No̱ of overlays do not match no̱ of monitors (${this.#overlays.length})`, monitors.map(({ index }) => index));
        const [mouseX, mouseY] = this.#desktopManager.pointer;
        for (const { index, workArea } of monitors) {
            const overlay = this.#overlays[index], xMax = workArea.x + workArea.width - overlay.width, yMax = workArea.y + workArea.height - overlay.height;
            if (focusedWindow?.get_monitor() === index) {
                const frame = focusedWindow.get_frame_rect(), anchorX = Math.clamp(frame.x + frame.width / 2 - overlay.width / 2, workArea.x, xMax), anchorY = Math.clamp(frame.y + frame.height / 2 - overlay.width / 2, workArea.y, yMax);
                overlay.placeAt(anchorX, anchorY);
            }
            else if (workArea.x <= mouseX && mouseX <= (workArea.x + workArea.width) &&
                workArea.y <= mouseY && mouseY <= (workArea.y + workArea.height)) {
                overlay.placeAt(Math.clamp(mouseX + overlay.popupOffsetX, workArea.x, xMax), Math.clamp(mouseY + overlay.popupOffsetY, workArea.y, yMax));
            }
            else {
                overlay.x = workArea.x + workArea.width / 2 - overlay.width / 2;
                overlay.y = workArea.y + workArea.height / 2 - overlay.height / 2;
            }
        }
    }
    #onGridVisibleChanged(source) {
        if (this.#syncInProgress) {
            return;
        }
        this.#syncInProgress = true;
        this.#overlays
            .filter(({ visible }) => visible !== source.visible)
            .forEach(o => source.visible ? o.show() : o.hide());
        this.#syncInProgress = false;
        this.#dispatch({ type: 3, visible: source.visible });
    }
    #onGridSizeChanged(source) {
        if (this.#syncInProgress) {
            return;
        }
        this.#syncInProgress = true;
        for (const overlay of this.#overlays) {
            if (overlay !== source) {
                overlay.gridSize = source.gridSize;
            }
        }
        this.#syncInProgress = false;
        this.#renderGridPreview(source.gridSize);
    }
    #onGridSelectionChanged(source) {
        if (!source.gridSelection) {
            this.#activeIdx = null;
            this.#preview.previewArea = null;
            return;
        }
        this.#activeIdx = this.#overlays.findIndex(o => o === source);
        this.#preview.previewArea = this.#desktopManager.selectionToArea(source.gridSelection, this.gridSize, this.#activeIdx, true);
    }
    #onGridHoverTileChanged(source) {
        if (!source.gridHoverTile) {
            this.#preview.previewArea = null;
            return;
        }
        const monitorIdx = this.#overlays.findIndex(overlay => overlay === source);
        this.#preview.previewArea = this.#desktopManager.selectionToArea({
            anchor: source.gridHoverTile,
            target: source.gridHoverTile,
        }, source.gridSize, monitorIdx, true);
    }
    #onDesktopEvent(event) {
        switch (event.type) {
            case 1:
                this.#syncTitleWithWindow(event.target);
                if (!event.target) {
                    this.toggleOverlays(true);
                }
                else if (!this.#settings.get_boolean("follow-cursor")) {
                    this.#placeOverlays(event.target);
                }
                else {
                    this.#placeOverlays();
                }
                return;
            case 2:
                this.#destroyOverlays();
                this.#renderOverlays();
                return;
            case 3:
                if (event.visible) {
                    this.toggleOverlays(true);
                }
                return;
        }
        return (() => { })();
    }
}
