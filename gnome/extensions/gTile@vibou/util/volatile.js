import { GarbageCollection } from "./gc.js";
export class VolatileStorage {
    #gc;
    #timeout;
    #stored;
    constructor(lifetime) {
        this.#gc = new GarbageCollection();
        this.#timeout = lifetime;
        this.#stored = null;
    }
    release() {
        this.#gc.release();
    }
    set store(t) {
        this.#gc.release();
        this.#stored = t;
        const id = setTimeout(() => this.#stored = null, this.#timeout);
        this.#gc.defer(() => clearTimeout(id));
    }
    get store() {
        return this.#stored;
    }
}
