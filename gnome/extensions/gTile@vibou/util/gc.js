export class GarbageCollection {
    #routines = [];
    defer(fn) {
        this.#routines.push(fn);
    }
    release() {
        while (this.#routines.length > 0) {
            this.#routines.pop()();
        }
    }
}
