import Gio from "gi://Gio";
import Shell from "gi://Shell";
import * as Main from "resource:///org/gnome/shell/ui/main.js";
import PanelButton from "../ui/PanelButton.js";
import { GarbageCollection } from "../util/gc.js";
import { AutoTileLayouts, DefaultGridSizes, adjust, pan } from "../util/grid.js";
import { GridSizeListParser, GridSpecParser, ResizePresetListParser } from "../util/parser.js";
import { VolatileStorage } from "../util/volatile.js";
import DesktopManager from "./DesktopManager.js";
import HotkeyManager, { DefaultKeyBindingGroups, SettingKeyToKeyBindingGroupLUT } from "./HotkeyManager.js";
import OverlayManager from "./OverlayManager.js";
import UserPreferences from "./UserPreferences.js";
export default class App {
    static #instance;
    #theme;
    #gc;
    #lastResizePreset;
    #settings;
    #gridSpecs;
    #globalKeyBindingGroups;
    #hotkeyManager;
    #desktopManager;
    #overlayManager;
    #panelIcon;
    static run(extension) {
        if (this.#instance) {
            throw new Error("App must have at most one instance.");
        }
        return this.#instance = new this(extension);
    }
    constructor(extension) {
        const mangledThemeName = extension.settings.
            get_string("theme").
            toLowerCase().
            replace(/[^a-z0-9]/g, "-");
        this.#theme = `gtile-${mangledThemeName}`;
        this.#gc = new GarbageCollection();
        this.#lastResizePreset = new VolatileStorage(2000);
        this.#settings = extension.settings;
        this.#gridSpecs = AutoTileLayouts(this.#settings);
        this.#globalKeyBindingGroups = Object
            .entries(SettingKeyToKeyBindingGroupLUT)
            .reduce((mask, [key, group]) => this.#settings.get_boolean(key)
            ? mask | group
            : mask, 0);
        this.#hotkeyManager = new HotkeyManager({
            settings: this.#settings,
            windowManager: Main.wm,
        });
        this.#gc.defer(() => this.#hotkeyManager.release());
        this.#desktopManager = new DesktopManager({
            shell: Shell.Global.get(),
            display: Shell.Global.get().display,
            layoutManager: Main.layoutManager,
            monitorManager: Shell.Global.get().backend.get_monitor_manager(),
            workspaceManager: Shell.Global.get().workspace_manager,
            userPreferences: new UserPreferences({ settings: this.#settings }),
        });
        this.#gc.defer(() => this.#desktopManager.release());
        const gridSizeConf = this.#settings.get_string("grid-sizes") ?? "";
        this.#overlayManager = new OverlayManager({
            theme: this.#theme,
            settings: this.#settings,
            gnomeSettings: extension.getSettings("org.gnome.desktop.interface"),
            presets: new GridSizeListParser(gridSizeConf).parse() ?? DefaultGridSizes,
            layoutManager: Main.layoutManager,
            desktopManager: this.#desktopManager,
        });
        this.#gc.defer(() => this.#overlayManager.release());
        this.#panelIcon = new PanelButton({ theme: this.#theme });
        this.#gc.defer(() => this.#panelIcon.destroy());
        Main.panel.addToStatusArea(extension.uuid, this.#panelIcon);
        this.#panelIcon.connect("button-press-event", () => this.#onUserAction({ type: 1 }));
        this.#settings.bind("show-icon", this.#panelIcon, "visible", Gio.SettingsBindFlags.GET);
        const chid = this.#settings.connect("changed", (_, key) => this.#onSettingsChanged(key));
        this.#gc.defer(() => this.#settings.disconnect(chid));
        this.#overlayManager.subscribe(this.#onOverlayEvent.bind(this));
        this.#hotkeyManager.subscribe(this.#onUserAction.bind(this));
        this.#hotkeyManager.setListeningGroups(this.#globalKeyBindingGroups);
    }
    release() {
        this.#gc.release();
        this.#lastResizePreset.release();
        App.#instance = undefined;
    }
    #getResizePreset(index) {
        const config = this.#settings.get_string(`resize${index}`) ?? "";
        const presets = new ResizePresetListParser(config).parse();
        if (!presets || presets.length === 0) {
            return null;
        }
        const [lastIndex, lastSubindex] = this.#lastResizePreset.store ?? [-1, -1];
        if (lastIndex !== index) {
            this.#lastResizePreset.store = [index, 0];
            return presets[0];
        }
        const nextSubindex = (lastSubindex + 1) % presets.length;
        this.#lastResizePreset.store = [index, nextSubindex];
        return presets[nextSubindex];
    }
    #onSettingsChanged(key) {
        const isHotkeyRelated = (key) => key in SettingKeyToKeyBindingGroupLUT;
        const isAutotileRelated = (key) => key.startsWith("autotile-gridspec-");
        isHotkeyRelated(key) && this.#onHotkeyGroupToggle(key);
        isAutotileRelated(key) && this.#onAutotileGridSpecChanged(key);
        key === "grid-sizes" && this.#onPresetsChanged();
    }
    #onHotkeyGroupToggle(key) {
        if (this.#settings.get_boolean(key)) {
            this.#globalKeyBindingGroups |= SettingKeyToKeyBindingGroupLUT[key];
        }
        else {
            this.#globalKeyBindingGroups &= ~SettingKeyToKeyBindingGroupLUT[key];
        }
    }
    #onAutotileGridSpecChanged(key) {
        const col = Number(key.split("-").pop());
        const value = this.#settings.get_string(key);
        const gridSpec = new GridSpecParser(value).parse();
        if (gridSpec) {
            this.#gridSpecs["cols"][col] = gridSpec;
        }
    }
    #onPresetsChanged() {
        const gridSizeConf = this.#settings.get_string("grid-sizes") ?? "";
        const gridSizes = new GridSizeListParser(gridSizeConf).parse();
        if (gridSizes && gridSizes.length > 0) {
            this.#overlayManager.presets = gridSizes;
        }
    }
    #onOverlayEvent(action) {
        switch (action.type) {
            case 1:
                this.#onUserAction({ type: 3 });
                return;
            case 2:
                this.#onUserAction({ type: 12, layout: action.layout });
                return;
            case 3:
                this.#hotkeyManager.setListeningGroups(action.visible
                    ? this.#globalKeyBindingGroups | DefaultKeyBindingGroups
                    : this.#globalKeyBindingGroups);
                return;
        }
        return (() => { })();
    }
    #onUserAction(action) {
        switch (action.type) {
            case 1:
                this.#overlayManager.toggleOverlays();
                return;
            case 2:
                this.#overlayManager.toggleOverlays(true);
                return;
            case 4:
                this.#overlayManager.iteratePreset();
                return;
        }
        const om = this.#overlayManager;
        const dm = this.#desktopManager;
        const window = dm.focusedWindow;
        if (!window)
            return;
        const monitorIdx = om.activeMonitor ?? window.get_monitor();
        const selection = om.getSelection(monitorIdx);
        switch (action.type) {
            case 3:
                if (selection) {
                    dm.applySelection(window, monitorIdx, om.gridSize, selection);
                    om.setSelection(null, monitorIdx);
                    this.#settings.get_boolean("auto-close") && om.toggleOverlays(true);
                }
                return;
            case 5:
                const curSel = selection ?? dm.windowToSelection(window, om.gridSize);
                const newSel = pan(curSel, om.gridSize, action.dir);
                om.setSelection(newSel, monitorIdx);
                return;
            case 6: {
                const curSel = selection ?? dm.windowToSelection(window, om.gridSize);
                const newSel = adjust(curSel, om.gridSize, action.dir, action.mode);
                om.setSelection(newSel, monitorIdx);
                return;
            }
            case 7: {
                dm.moveWindow(window, om.gridSize, action.dir);
                return;
            }
            case 8: {
                dm.resizeWindow(window, om.gridSize, action.dir, action.mode);
                return;
            }
            case 9:
                dm.autogrow(window);
                return;
            case 10: {
                const preset = this.#getResizePreset(action.preset);
                if (preset) {
                    const { gridSize, selection } = preset;
                    const targetCursorMonitor = this.#settings.get_boolean("target-presets-to-monitor-of-mouse");
                    const mIdx = targetCursorMonitor ? dm.pointerMonitorIdx : monitorIdx;
                    dm.applySelection(window, mIdx, gridSize, selection);
                }
                return;
            }
            case 11:
                dm.moveToMonitor(window);
                return;
            case 12:
                if (action.layout === "main" || action.layout === "main-inverted") {
                    dm.autotile(this.#gridSpecs[action.layout], monitorIdx);
                }
                else if (action.layout === "cols" && action.cols) {
                    const gridSpec = this.#gridSpecs[action.layout][action.cols];
                    if (gridSpec) {
                        dm.autotile(gridSpec, monitorIdx);
                    }
                }
                return;
        }
        return (() => { })();
    }
}
