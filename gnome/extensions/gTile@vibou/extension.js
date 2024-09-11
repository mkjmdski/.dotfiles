import GLib from "gi://GLib";
import { Extension } from "resource:///org/gnome/shell/extensions/extension.js";
import App from "./core/App.js";
export default class extends Extension {
    #app;
    #settings;
    enable() {
        console.log(`Enable ${this.metadata.uuid} (GLib v${GLib.MAJOR_VERSION}.${GLib.MINOR_VERSION}.${GLib.MICRO_VERSION})`);
        this.#app = App.run(this);
    }
    disable() {
        this.#app?.release();
        this.#app = undefined;
        this.#settings = undefined;
    }
    get settings() {
        if (!this.#settings) {
            this.#settings = this.getSettings();
        }
        return this.#settings;
    }
}
