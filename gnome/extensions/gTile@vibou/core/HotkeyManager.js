import Meta from "gi://Meta";
import Shell from "gi://Shell";
export const DefaultKeyBindingGroups = 2 | 4 | 16;
export const SettingKeyToKeyBindingGroupLUT = {
    "global-auto-tiling": 4,
    "global-presets": 16,
    "moveresize-enabled": 8,
};
export default class {
    #settings;
    #windowManager;
    #bindings;
    #dispatchCallbacks;
    #keyBindingGroupMask;
    constructor({ settings, windowManager }) {
        this.#settings = settings;
        this.#windowManager = windowManager;
        this.#bindings = {
            [1]: new Set(),
            [2]: new Set(),
            [4]: new Set(),
            [8]: new Set(),
            [16]: new Set(),
        };
        this.#dispatchCallbacks = [];
        this.#keyBindingGroupMask = 1;
        this.#registerGlobalHotkeys();
    }
    release() {
        this.#keyBindingGroupMask = 0;
        this.#dispatchCallbacks = [];
        this.#registerGlobalHotkeys();
        this.#registerOverlayHotkeys();
        this.#registerAutotileHotkeys();
        this.#registerActionHotkeys();
        this.#registerPresetHotkeys();
    }
    setListeningGroups(...keybindingGroups) {
        this.#keyBindingGroupMask = keybindingGroups.reduce((mask, flag) => mask | flag, 1);
        this.#registerOverlayHotkeys();
        this.#registerAutotileHotkeys();
        this.#registerActionHotkeys();
        this.#registerPresetHotkeys();
    }
    ;
    subscribe(fn) {
        this.#dispatchCallbacks.push(fn);
    }
    #dispatch(action) {
        for (const cb of this.#dispatchCallbacks) {
            cb(action);
        }
    }
    #registerGlobalHotkeys() {
        const kb = (name, dispatchEvent) => this.#registerKeybinding(1, name, () => {
            this.#dispatch(dispatchEvent);
        });
        kb("show-toggle-tiling", { type: 1 });
    }
    #registerOverlayHotkeys() {
        const kb = (name, dispatchEvent) => this.#registerKeybinding(2, name, () => {
            this.#dispatch(dispatchEvent);
        });
        kb("cancel-tiling", { type: 2 });
        kb("change-grid-size", { type: 4 });
        kb("move-up", { type: 5, dir: "north" });
        kb("move-right", { type: 5, dir: "east" });
        kb("move-down", { type: 5, dir: "south" });
        kb("move-left", { type: 5, dir: "west" });
        kb("move-next-monitor", { type: 11 });
        kb("contract-left", { type: 6, mode: "shrink", dir: "west" });
        kb("contract-right", { type: 6, mode: "shrink", dir: "east" });
        kb("contract-up", { type: 6, mode: "shrink", dir: "north" });
        kb("contract-down", { type: 6, mode: "shrink", dir: "south" });
        kb("expand-left", { type: 6, mode: "extend", dir: "west" });
        kb("expand-right", { type: 6, mode: "extend", dir: "east" });
        kb("expand-up", { type: 6, mode: "extend", dir: "north" });
        kb("expand-down", { type: 6, mode: "extend", dir: "south" });
        kb("set-tiling", { type: 3 });
        kb("snap-to-neighbors", { type: 9 });
    }
    #registerAutotileHotkeys() {
        const kb = (name, dispatchEvent) => this.#registerKeybinding(4, name, () => {
            this.#dispatch(dispatchEvent);
        });
        kb("autotile-main", { type: 12, layout: "main" });
        kb("autotile-main-inverted", {
            type: 12,
            layout: "main-inverted"
        });
        kb("autotile-1", { type: 12, layout: "cols", cols: 1 });
        kb("autotile-2", { type: 12, layout: "cols", cols: 2 });
        kb("autotile-3", { type: 12, layout: "cols", cols: 3 });
        kb("autotile-4", { type: 12, layout: "cols", cols: 4 });
        kb("autotile-5", { type: 12, layout: "cols", cols: 5 });
        kb("autotile-6", { type: 12, layout: "cols", cols: 6 });
        kb("autotile-7", { type: 12, layout: "cols", cols: 7 });
        kb("autotile-8", { type: 12, layout: "cols", cols: 8 });
        kb("autotile-9", { type: 12, layout: "cols", cols: 9 });
        kb("autotile-10", { type: 12, layout: "cols", cols: 10 });
    }
    #registerActionHotkeys() {
        const kb = (name, dispatchEvent) => this.#registerKeybinding(8, name, () => {
            this.#dispatch(dispatchEvent);
        });
        kb("action-autotile-main", { type: 12, layout: "main" });
        kb("action-autotile-main-inverted", {
            type: 12,
            layout: "main-inverted"
        });
        kb("action-change-tiling", { type: 4 });
        {
            const mode = "shrink";
            kb("action-contract-top", { type: 8, mode, dir: "north" });
            kb("action-contract-right", { type: 8, mode, dir: "east" });
            kb("action-contract-bottom", { type: 8, mode, dir: "south" });
            kb("action-contract-left", { type: 8, mode, dir: "west" });
        }
        {
            const mode = "extend";
            kb("action-expand-top", { type: 8, mode, dir: "north" });
            kb("action-expand-right", { type: 8, mode, dir: "east" });
            kb("action-expand-bottom", { type: 8, mode, dir: "south" });
            kb("action-expand-left", { type: 8, mode, dir: "west" });
        }
        kb("action-move-up", { type: 7, dir: "north" });
        kb("action-move-right", { type: 7, dir: "east" });
        kb("action-move-down", { type: 7, dir: "south" });
        kb("action-move-left", { type: 7, dir: "west" });
        kb("action-move-next-monitor", { type: 11 });
    }
    #registerPresetHotkeys() {
        const kb = (name, dispatchEvent) => this.#registerKeybinding(16, name, () => {
            this.#dispatch(dispatchEvent);
        });
        kb("preset-resize-1", { type: 10, preset: 1 });
        kb("preset-resize-2", { type: 10, preset: 2 });
        kb("preset-resize-3", { type: 10, preset: 3 });
        kb("preset-resize-4", { type: 10, preset: 4 });
        kb("preset-resize-5", { type: 10, preset: 5 });
        kb("preset-resize-6", { type: 10, preset: 6 });
        kb("preset-resize-7", { type: 10, preset: 7 });
        kb("preset-resize-8", { type: 10, preset: 8 });
        kb("preset-resize-9", { type: 10, preset: 9 });
        kb("preset-resize-10", { type: 10, preset: 10 });
        kb("preset-resize-11", { type: 10, preset: 11 });
        kb("preset-resize-12", { type: 10, preset: 12 });
        kb("preset-resize-13", { type: 10, preset: 13 });
        kb("preset-resize-14", { type: 10, preset: 14 });
        kb("preset-resize-15", { type: 10, preset: 15 });
        kb("preset-resize-16", { type: 10, preset: 16 });
        kb("preset-resize-17", { type: 10, preset: 17 });
        kb("preset-resize-18", { type: 10, preset: 18 });
        kb("preset-resize-19", { type: 10, preset: 19 });
        kb("preset-resize-20", { type: 10, preset: 20 });
        kb("preset-resize-21", { type: 10, preset: 21 });
        kb("preset-resize-22", { type: 10, preset: 22 });
        kb("preset-resize-23", { type: 10, preset: 23 });
        kb("preset-resize-24", { type: 10, preset: 24 });
        kb("preset-resize-25", { type: 10, preset: 25 });
        kb("preset-resize-26", { type: 10, preset: 26 });
        kb("preset-resize-27", { type: 10, preset: 27 });
        kb("preset-resize-28", { type: 10, preset: 28 });
        kb("preset-resize-29", { type: 10, preset: 29 });
        kb("preset-resize-30", { type: 10, preset: 30 });
    }
    #registerKeybinding(group, name, handler) {
        if ((group & this.#keyBindingGroupMask) !== group) {
            if (this.#bindings[group].has(name)) {
                this.#bindings[group].delete(name);
                this.#windowManager.removeKeybinding(name);
            }
            return;
        }
        if (!this.#bindings[group].has(name)) {
            this.#bindings[group].add(name);
            this.#windowManager.addKeybinding(name, this.#settings, Meta.KeyBindingFlags.NONE, Shell.ActionMode.NORMAL, handler);
        }
    }
}
