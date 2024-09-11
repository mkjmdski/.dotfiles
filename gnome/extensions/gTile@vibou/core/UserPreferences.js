export default class {
    #settings;
    constructor({ settings }) {
        this.#settings = settings;
    }
    getInset(primary) {
        const setting = primary ? "primary" : "secondary";
        return {
            top: this.#settings.get_int(`insets-${setting}-top`),
            bottom: this.#settings.get_int(`insets-${setting}-bottom`),
            left: this.#settings.get_int(`insets-${setting}-left`),
            right: this.#settings.get_int(`insets-${setting}-right`),
        };
    }
    getSpacing() {
        return this.#settings.get_int("window-spacing");
    }
}
