import { LexicalError, Scanner } from "./scanner.js";
class ParseError extends Error {
}
class Parser {
    scanner;
    token;
    constructor(input) {
        this.scanner = new Scanner(input);
    }
    accept(which) {
        if (which) {
            if (which.kind !== this.token.kind) {
                throw new ParseError(`Unexpected token ${this.token.kind}. Want ${which.kind}`);
            }
            else if (which.raw && which.raw !== this.token.raw) {
                throw new ParseError(`Unexpected constant literal ${this.token.raw}. Want ${which.raw}`);
            }
        }
        const raw = this.token.raw;
        this.token = this.scanner.scan();
        return raw;
    }
    acceptIf(kind) {
        if (this.token.kind === kind) {
            this.token = this.scanner.scan();
            return true;
        }
        return false;
    }
}
export class GridSizeListParser extends Parser {
    constructor(input) {
        super(input);
    }
    parse() {
        try {
            this.token = this.scanner.scan();
            return this.#parseList();
        }
        catch (e) {
            if (e instanceof LexicalError || e instanceof ParseError) {
                console.warn(`Failed to parse grid-size list. Input: "${this.scanner.input}".`, `Error: ${e.message}`);
                return null;
            }
            throw e;
        }
    }
    #parseList() {
        const gridSizes = [];
        switch (this.token.kind) {
            case 7:
                return gridSizes;
            case 1:
                do {
                    gridSizes.push(this.#parseGridSize());
                } while (this.acceptIf(3));
                return gridSizes;
        }
        throw new ParseError(`Unexpected token "${this.token.raw}" ` +
            `(type: ${this.token.kind}) at pos ${this.token.position}.`);
    }
    #parseGridSize() {
        const cols = Math.clamp(this.#parseNumber(), 1, 64);
        this.accept({ kind: 2, raw: "x" });
        const rows = Math.clamp(this.#parseNumber(), 1, 64);
        return { cols, rows };
    }
    #parseNumber() {
        return Number(this.accept({ kind: 1 }));
    }
}
export class ResizePresetListParser extends Parser {
    constructor(input) {
        super(input);
    }
    parse() {
        try {
            this.token = this.scanner.scan();
            return this.#parseList();
        }
        catch (e) {
            if (e instanceof LexicalError || e instanceof ParseError) {
                console.warn(`Failed to parse preset list. Input: "${this.scanner.input}".`, `Error: ${e.message}`);
                return null;
            }
            throw e;
        }
    }
    #parseList() {
        const presets = [];
        switch (this.token.kind) {
            case 7:
                return presets;
            case 1:
                const gridSize = this.#parseGridSize();
                const selection = this.#parseSelection();
                presets.push({ gridSize, selection });
                while (this.acceptIf(3)) {
                    const presetOrSelection = this.#parsePresetOrSelection();
                    if (this.#isPreset(presetOrSelection)) {
                        presets.push(presetOrSelection);
                    }
                    else {
                        const { gridSize: { cols, rows } } = presets[presets.length - 1];
                        presets.push({
                            gridSize: { cols, rows },
                            selection: presetOrSelection,
                        });
                    }
                }
                return presets;
        }
        throw new ParseError(`Unexpected token "${this.token.raw}" ` +
            `(type: ${this.token.kind}) at pos ${this.token.position}.`);
    }
    #parsePresetOrSelection() {
        const num = this.#parseNumber();
        switch (this.token.kind) {
            case 2:
                this.accept({ kind: 2, raw: "x" });
                const rows = this.#parseNumber();
                const selection = this.#parseSelection();
                return {
                    gridSize: { cols: num, rows },
                    selection
                };
            case 4:
                this.accept();
                const row = this.#parseNumber();
                const target = this.#parseOffset();
                return {
                    anchor: { col: num - 1, row: row - 1 },
                    target,
                };
        }
        throw new ParseError(`Unexpected token "${this.token.raw}" ` +
            `(type: ${this.token.kind}) at pos ${this.token.position}.`);
    }
    #parseSelection() {
        const anchor = this.#parseOffset();
        const target = this.#parseOffset();
        return { anchor, target };
    }
    #parseGridSize() {
        const cols = this.#parseNumber();
        this.accept({ kind: 2, raw: "x" });
        const rows = this.#parseNumber();
        return { cols, rows };
    }
    #parseOffset() {
        const col = this.#parseNumber() - 1;
        this.accept({ kind: 4 });
        const row = this.#parseNumber() - 1;
        return { col, row };
    }
    #parseNumber() {
        return Number(this.accept({ kind: 1 }));
    }
    #isPreset(o) {
        return "gridSize" in o;
    }
}
export class GridSpecParser extends Parser {
    parse() {
        try {
            this.token = this.scanner.scan();
            return this.#parseGridSpec();
        }
        catch (e) {
            if (e instanceof LexicalError || e instanceof ParseError) {
                console.warn(`Failed to parse GridSpec. Input: "${this.scanner.input}".`, `Error: ${e.message}`);
                return null;
            }
            throw e;
        }
    }
    #parseGridSpec() {
        switch (this.token.kind) {
            case 7:
                return { mode: "cols", cells: [] };
            case 2:
                return this.#parseColRowSpec();
        }
        throw new ParseError(`Unexpected token "${this.token.raw}" ` +
            `(type: ${this.token.kind}) at pos ${this.token.position}.`);
    }
    #parseColRowSpec() {
        switch (this.token.kind) {
            case 2:
                const mode = this.token.raw;
                if (mode !== "cols" && mode !== "rows") {
                    break;
                }
                this.accept();
                this.accept({ kind: 5 });
                const cells = [];
                do {
                    cells.push(this.#parseCellSpec());
                } while (this.acceptIf(3));
                this.accept({ kind: 6 });
                return { mode, cells };
        }
        throw new ParseError(`Unexpected token "${this.token.raw}" ` +
            `(type: ${this.token.kind}) at pos ${this.token.position}.`);
    }
    #parseCellSpec() {
        const weight = this.#parseNumber();
        let dynamic = false;
        let child;
        if (this.token.kind === 2 && this.token.raw === "d") {
            this.accept();
            dynamic = true;
        }
        else if (this.acceptIf(4)) {
            child = this.#parseColRowSpec();
        }
        return { weight, dynamic, child };
    }
    #parseNumber() {
        return Number(this.accept({ kind: 1 }));
    }
}
