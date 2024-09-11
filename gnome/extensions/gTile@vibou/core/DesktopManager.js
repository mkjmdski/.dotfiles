import Meta from "gi://Meta";
import Mtk from "gi://Mtk";
import { GarbageCollection } from "../util/gc.js";
import { adjust, pan } from "../util/grid.js";
const TitleBlacklist = [
    /;BDHF$/,
];
export default class {
    #gc;
    #shell;
    #display;
    #layoutManager;
    #workspaceManager;
    #userPreferences;
    #dispatchCallbacks;
    constructor({ shell, display, layoutManager, monitorManager, workspaceManager, userPreferences, }) {
        this.#gc = new GarbageCollection();
        this.#shell = shell;
        this.#display = display;
        this.#layoutManager = layoutManager;
        this.#workspaceManager = workspaceManager;
        this.#userPreferences = userPreferences;
        this.#dispatchCallbacks = [];
        {
            const chid = monitorManager.connect("monitors-changed", () => {
                this.#dispatch({ type: 2 });
            });
            this.#gc.defer(() => monitorManager.disconnect(chid));
        }
        {
            const chid = display.connect("notify::focus-window", () => {
                this.#dispatch({ type: 1, target: display.focus_window });
            });
            this.#gc.defer(() => display.disconnect(chid));
        }
        {
            const chid = layoutManager.overviewGroup.connect("notify::visible", g => {
                this.#dispatch({ type: 3, visible: g.visible });
            });
            this.#gc.defer(() => layoutManager.disconnect(chid));
        }
    }
    release() {
        this.#dispatchCallbacks = [];
        this.#gc.release();
    }
    subscribe(fn) {
        this.#dispatchCallbacks.push(fn);
    }
    get focusedWindow() {
        return this.#display.focus_window ?? null;
    }
    get monitors() {
        const monitors = this.#layoutManager.monitors;
        const workAreas = monitors.map(m => this.#workspaceManager
            .get_active_workspace()
            .get_work_area_for_monitor(m.index));
        return this.#layoutManager.monitors.map((m, index) => ({
            index: m.index,
            scale: m.geometryScale,
            resolution: { x: m.x, y: m.y, width: m.width, height: m.height },
            workArea: {
                x: workAreas[index].x,
                y: workAreas[index].y,
                width: workAreas[index].width,
                height: workAreas[index].height,
            }
        }));
    }
    get pointer() {
        const [x, y] = this.#shell.get_pointer();
        return [x, y];
    }
    get pointerMonitorIdx() {
        const [mouseX, mouseY] = this.#shell.get_pointer();
        for (const monitor of this.#layoutManager.monitors) {
            if (monitor.x <= mouseX && mouseX <= (monitor.x + monitor.width) &&
                monitor.y <= mouseY && mouseY <= (monitor.y + monitor.height)) {
                return monitor.index;
            }
        }
        return 0;
    }
    moveToMonitor(target, monitorIdx) {
        monitorIdx = monitorIdx ?? (target.get_monitor() + 1) % this.monitors.length;
        target.unmaximize(Meta.MaximizeFlags.BOTH);
        target.move_to_monitor(monitorIdx);
    }
    applySelection(target, monitorIdx, gridSize, selection) {
        const projectedArea = this.selectionToArea(selection, gridSize, monitorIdx);
        this.#fit(target, projectedArea);
    }
    selectionToArea(selection, gridSize, monitorIdx, preview = false) {
        const { cols, rows } = gridSize, relX = Math.min(selection.anchor.col, selection.target.col) / cols, relY = Math.min(selection.anchor.row, selection.target.row) / rows, relW = (Math.abs(selection.anchor.col - selection.target.col) + 1) / cols, relH = (Math.abs(selection.anchor.row - selection.target.row) + 1) / rows, workArea = this.#workArea(monitorIdx), spacing = preview ? this.#userPreferences.getSpacing() : 0;
        return {
            x: workArea.x + workArea.width * relX + spacing,
            y: workArea.y + workArea.height * relY + spacing,
            width: workArea.width * relW - spacing * 2,
            height: workArea.height * relH - spacing * 2,
        };
    }
    windowToSelection(window, gridSize, snap = "closest") {
        const frame = this.#frameRect(window);
        const workArea = this.#workArea(window.get_monitor());
        const relativeRect = {
            x: (frame.x - workArea.x) / workArea.width,
            y: (frame.y - workArea.y) / workArea.height,
            width: frame.width / workArea.width,
            height: frame.height / workArea.height,
        };
        return this.#rectToSelection(relativeRect, gridSize, snap);
    }
    autogrow(target) {
        const monitorIdx = target.get_monitor();
        const workArea = this.#workArea(monitorIdx);
        const [_, frame] = workArea.intersect(this.#frameRect(target));
        const workspace = target.get_workspace();
        const collisionWindows = workspace.list_windows().filter(win => !(win === target ||
            win.minimized ||
            win.get_frame_type() !== Meta.FrameType.NORMAL ||
            TitleBlacklist.some(p => p.test(win.title ?? "")) ||
            win.get_monitor() !== monitorIdx ||
            frame.contains_rect(this.#frameRect(win)) ||
            frame.intersect(this.#frameRect(win))[0])).map(win => this.#frameRect(win));
        const doShareXAxis = (r, o) => r.x < (o.x + o.width) && o.x < (r.x + r.width), doShareYAxis = (r, o) => r.y < (o.y + o.height) && o.y < (r.y + r.height), maxWestBound = Math.max(...collisionWindows
            .filter(win => this.#isWestOf(win, frame) && doShareYAxis(win, frame))
            .map(win => win.x + win.width)), maxNorthBound = Math.max(...collisionWindows
            .filter(win => this.#isNorthOf(win, frame) && doShareXAxis(win, frame))
            .map(win => win.y + win.height)), maxEastBound = Math.min(...collisionWindows
            .filter(win => this.#isEastOf(win, frame) && doShareYAxis(win, frame))
            .map(win => win.x)), maxSouthBound = Math.min(...collisionWindows
            .filter(win => this.#isSouthOf(win, frame) && doShareXAxis(win, frame))
            .map(win => win.y));
        const x = Math.max(maxWestBound, workArea.x);
        const y = Math.max(maxNorthBound, workArea.y);
        const optimalFrame = new Mtk.Rectangle({
            x, y,
            width: Math.min(maxEastBound, workArea.x + workArea.width) - x,
            height: Math.min(maxSouthBound, workArea.y + workArea.height) - y,
        });
        const remainingColliders = collisionWindows.filter(win => optimalFrame.intersect(win)[0] || optimalFrame.contains_rect(win));
        const root = this.#tree(frame, optimalFrame, remainingColliders);
        this.#fit(target, this.#findBest(root));
    }
    autotile(spec, monitorIdx) {
        const [dedicated, dynamic] = this.#gridSpecToAreas(spec);
        const workArea = this.#workArea(monitorIdx);
        const windows = this.#workspaceManager.get_active_workspace().list_windows()
            .filter(win => !(win.minimized ||
            win.get_monitor() !== monitorIdx ||
            win.get_frame_type() !== Meta.FrameType.NORMAL ||
            TitleBlacklist.some(p => p.test(win.title ?? ""))));
        const project = (rect, canvas) => ({
            x: canvas.x + canvas.width * rect.x,
            y: canvas.y + canvas.height * rect.y,
            width: canvas.width * rect.width,
            height: canvas.height * rect.height,
        });
        const focusedIdx = windows.findIndex(w => w.has_focus());
        if (focusedIdx && dedicated.length > 0) {
            const [largestIdx] = dedicated.reduce(([accuIdx, accuArea], rect, idx) => rect.width * rect.height > accuArea
                ? [idx, rect.width * rect.height]
                : [accuIdx, accuArea], [-1, 0]);
            const projectedArea = project(dedicated[largestIdx], workArea);
            this.#fit(windows[focusedIdx], projectedArea);
            windows.splice(focusedIdx, 1);
            dedicated.splice(largestIdx, 1);
        }
        for (let i = 0; i < dedicated.length && i < windows.length; ++i) {
            this.#fit(windows[i], project(dedicated[i], workArea));
        }
        windows.splice(0, dedicated.length);
        for (let i = 0; i < dynamic.length; i++) {
            const mustFitAtLeastN = Math.floor(windows.length / dynamic.length);
            const mustTakeOverflowWindow = i < (windows.length % dynamic.length);
            const n = mustFitAtLeastN + (mustTakeOverflowWindow ? 1 : 0);
            let j = i;
            for (const area of this.#splitN(dynamic[i], n)) {
                this.#fit(windows[j], project(area, workArea));
                j += dynamic.length;
            }
        }
    }
    moveWindow(target, gridSize, dir) {
        const strategy = dir === "west" || dir === "north" ? "shrink" : "grow", frameFit = this.windowToSelection(target, gridSize, strategy), targetSelection = pan(frameFit, gridSize, dir), nwTile = {
            col: Math.min(targetSelection.anchor.col, targetSelection.target.col),
            row: Math.min(targetSelection.anchor.row, targetSelection.target.row),
        }, asSelection = { anchor: nwTile, target: nwTile }, monitorIdx = target.get_monitor(), targetArea = this.selectionToArea(asSelection, gridSize, monitorIdx), frame = this.#frameRect(target), newX = (dir === "north" || dir === "south") ? frame.x : targetArea.x, newY = (dir === "east" || dir === "west") ? frame.y : targetArea.y;
        this.#moveResize(target, newX, newY);
    }
    resizeWindow(target, gridSize, dir, mode) {
        const strategy = mode === "extend" ? "shrink" : "grow", frameFit = this.windowToSelection(target, gridSize, strategy), targetSelection = adjust(frameFit, gridSize, dir, mode), monitorIdx = target.get_monitor(), targetArea = this.selectionToArea(targetSelection, gridSize, monitorIdx), frame = this.#frameRect(target);
        let rect;
        switch (dir) {
            case "north": {
                const height = frame.y + frame.height - targetArea.y;
                rect = { x: frame.x, y: targetArea.y, width: frame.width, height };
                break;
            }
            case "south": {
                const height = targetArea.y + targetArea.height - frame.y;
                rect = { x: frame.x, y: frame.y, width: frame.width, height };
                break;
            }
            case "east": {
                const width = targetArea.x + targetArea.width - frame.x;
                rect = { x: frame.x, y: frame.y, width, height: frame.height };
                break;
            }
            case "west": {
                const width = frame.x + frame.width - targetArea.x;
                rect = { x: targetArea.x, y: frame.y, width, height: frame.height };
                break;
            }
        }
        this.#fit(target, rect);
    }
    #dispatch(event) {
        for (const cb of this.#dispatchCallbacks) {
            cb(event);
        }
    }
    #moveResize(target, x, y, size) {
        target.unmaximize(Meta.MaximizeFlags.BOTH);
        const spacing = this.#userPreferences.getSpacing();
        x += spacing;
        y += spacing;
        target.move_frame(true, x, y);
        if (size) {
            const { width: w, height: h } = size;
            target.move_resize_frame(true, x, y, w - spacing * 2, h - spacing * 2);
        }
    }
    #fit(target, { x, y, width, height }) {
        this.#moveResize(target, x, y, { width, height });
    }
    #frameRect(target) {
        const frame = target.get_frame_rect();
        const spacing = this.#userPreferences.getSpacing();
        frame.x -= spacing;
        frame.y -= spacing;
        frame.width += spacing * 2;
        frame.height += spacing * 2;
        return frame;
    }
    #workArea(monitorIdx) {
        const isPrimaryMonitor = this.#layoutManager.primaryIndex === monitorIdx, inset = this.#userPreferences.getInset(isPrimaryMonitor), workArea = this.#workspaceManager
            .get_active_workspace()
            .get_work_area_for_monitor(monitorIdx), top = Math.clamp(inset.top, 0, Math.floor(workArea.height / 2)), bottom = Math.clamp(inset.bottom, 0, Math.floor(workArea.height / 2)), left = Math.clamp(inset.left, 0, Math.floor(workArea.width / 2)), right = Math.clamp(inset.right, 0, Math.floor(workArea.width / 2)), spacing = this.#userPreferences.getSpacing();
        workArea.x += left - spacing;
        workArea.y += top - spacing;
        workArea.width -= left + right - spacing * 2;
        workArea.height -= top + bottom - spacing * 2;
        return workArea;
    }
    #rectToSelection({ x, y, width, height }, { cols, rows }, snap, ε = .01) {
        const roundNear = (n, ε) => Math.abs(n - Math.round(n)) <= ε ? Math.round(n) : n, exactNwX = Math.clamp(roundNear(cols * x, ε), 0, cols - 1), exactNwY = Math.clamp(roundNear(rows * y, ε), 0, rows - 1), exactSeX = Math.clamp(roundNear(cols * (x + width), ε), 1, cols), exactSeY = Math.clamp(roundNear(rows * (y + height), ε), 1, rows);
        const discretize = snap === "shrink" ? Math.floor : snap === "grow" ? Math.ceil : Math.round;
        const transformNW = (n) => n * (snap === "closest" ? 1 : -1);
        let alignedNwX = transformNW(discretize(transformNW(exactNwX)));
        let alignedNwY = transformNW(discretize(transformNW(exactNwY)));
        let alignedSeX = discretize(exactSeX);
        let alignedSeY = discretize(exactSeY);
        if (alignedNwX === alignedSeX) {
            const NwXAlt = transformNW(Math.ceil(transformNW(exactNwX)));
            const SeXAlt = Math.ceil(exactSeX);
            if (NwXAlt === SeXAlt) {
                alignedSeX += 1;
            }
            else if (Math.abs(NwXAlt - exactNwX) < Math.abs(SeXAlt - exactSeX)) {
                alignedNwX = NwXAlt;
            }
            else {
                alignedSeX = SeXAlt;
            }
        }
        if (alignedNwY === alignedSeY) {
            const NwYAlt = transformNW(Math.ceil(transformNW(exactNwY)));
            const SeYAlt = Math.ceil(exactSeY);
            if (NwYAlt === SeYAlt) {
                alignedSeY += 1;
            }
            else if (Math.abs(NwYAlt - exactNwY) < Math.abs(SeYAlt - exactSeY)) {
                alignedNwY = NwYAlt;
            }
            else {
                alignedSeY = SeYAlt;
            }
        }
        return {
            anchor: { col: alignedNwX, row: alignedNwY },
            target: { col: alignedSeX - 1, row: alignedSeY - 1 },
        };
    }
    #gridSpecToAreas(spec, x = 0, y = 0, w = 1, h = 1) {
        const regularCells = [];
        const dynamicCells = [];
        const totalWeight = spec.cells.reduce((sum, c) => sum + c.weight, 0);
        for (const cell of spec.cells) {
            const ratio = cell.weight / totalWeight;
            const width = spec.mode === "cols" ? w * ratio : w;
            const height = spec.mode === "rows" ? h * ratio : h;
            if (cell.child) {
                const [dedicated, dynamic] = this.#gridSpecToAreas(cell.child, x, y, width, height);
                regularCells.push(...dedicated);
                dynamicCells.push(...dynamic);
            }
            else if (cell.dynamic) {
                dynamicCells.push({ x, y, width, height });
            }
            else {
                regularCells.push({ x, y, width, height });
            }
            if (spec.mode === "cols")
                x += width;
            if (spec.mode === "rows")
                y += height;
        }
        return [regularCells, dynamicCells];
    }
    #splitN(rect, n, axis) {
        const result = [];
        const { width, height } = rect;
        axis = axis ?? width > height ? "x" : "y";
        let i = n, { x, y } = rect;
        while (i--) {
            result.push({
                x, y,
                width: axis === "x" ? width / n : width,
                height: axis === "y" ? height / n : height,
            });
            if (axis === "x")
                x += width / n;
            if (axis === "y")
                y += height / n;
        }
        return result;
    }
    #tree(frame, bounds, collisionObjects) {
        const self = { data: bounds };
        if (collisionObjects.length === 0) {
            return self;
        }
        const win = collisionObjects.splice(0, 1)[0];
        const WE = this.#isWestOf(win, frame) ? "west" : "east";
        const optimalFrameX = this.#noCollide(bounds, win, WE);
        self.left = this.#tree(frame, optimalFrameX, collisionObjects.filter(win => optimalFrameX.intersect(win)[0] || optimalFrameX.contains_rect(win)));
        const NS = this.#isNorthOf(win, frame) ? "north" : "south";
        const optimalFrameY = this.#noCollide(bounds, win, NS);
        self.right = this.#tree(frame, optimalFrameY, collisionObjects.filter(win => optimalFrameY.intersect(win)[0] || optimalFrameY.contains_rect(win)));
        return self;
    }
    #findBest(tree) {
        let left, right;
        if (tree.left) {
            left = this.#findBest(tree.left);
        }
        if (tree.right) {
            right = this.#findBest(tree.right);
        }
        if (!left && !right)
            return tree.data;
        if (!left && right)
            return right;
        if (left && !right)
            return left;
        if (left.area() > right.area())
            return left;
        return right;
    }
    #isWestOf(r, o) { return o.x >= (r.x + r.width); }
    #isEastOf(r, o) { return this.#isWestOf(o, r); }
    #isNorthOf(r, o) { return o.y >= (r.y + r.height); }
    #isSouthOf(r, o) { return this.#isNorthOf(o, r); }
    #noCollide(bounds, collider, dir) {
        const newBounds = new Mtk.Rectangle({
            x: bounds.x,
            y: bounds.y,
            width: bounds.width,
            height: bounds.height,
        });
        switch (dir) {
            case "east":
                newBounds.width = collider.x - newBounds.x;
                break;
            case "west":
                const oldX = newBounds.x;
                newBounds.x = collider.x + collider.width;
                newBounds.width -= newBounds.x - oldX;
                break;
            case "north":
                const oldY = newBounds.y;
                newBounds.y = collider.y + collider.height;
                newBounds.height -= newBounds.y - oldY;
                break;
            case "south":
                newBounds.height = collider.y - newBounds.y;
        }
        return newBounds;
    }
}
