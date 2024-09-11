var _a;
export class LexicalError extends Error {
}
;
export class Scanner {
    static DigitRegex = /^[0-9]$/;
    static CharRegex = /^[a-z]$/;
    #input;
    #position;
    #buffer;
    constructor(input) {
        this.#input = input;
        this.#position = 0;
        this.#buffer = "";
    }
    scan() {
        while (this.#input[this.#position] === " ")
            ++this.#position;
        const position = this.#position;
        const kind = this.#scanToken();
        const token = { kind, position, raw: this.#buffer };
        this.#buffer = "";
        return token;
    }
    get input() {
        return this.#input;
    }
    #take() {
        this.#buffer += this.#input[this.#position++];
    }
    #scanToken() {
        const char = this.#input[this.#position];
        switch (char) {
            case "1":
            case "2":
            case "3":
            case "4":
            case "5":
            case "6":
            case "7":
            case "8":
            case "9":
                do {
                    this.#take();
                } while (_a.DigitRegex.test(this.#input[this.#position]));
                return 1;
            case "a":
            case "b":
            case "c":
            case "d":
            case "e":
            case "f":
            case "g":
            case "h":
            case "i":
            case "j":
            case "k":
            case "l":
            case "m":
            case "n":
            case "o":
            case "p":
            case "q":
            case "r":
            case "s":
            case "t":
            case "u":
            case "v":
            case "w":
            case "x":
            case "y":
            case "z":
                do {
                    this.#take();
                } while (_a.CharRegex.test(this.#input[this.#position]));
                return 2;
            case ",":
                this.#take();
                return 3;
            case ":":
                this.#take();
                return 4;
            case "(":
                this.#take();
                return 5;
            case ")":
                this.#take();
                return 6;
            case undefined:
                return 7;
        }
        throw new LexicalError(`Unexpected character "${char}" at position ${this.#position}.`);
    }
}
_a = Scanner;
