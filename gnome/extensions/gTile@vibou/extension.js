const installedApp = {};

const registerExtension = function(i, e, d) {
  installedApp.init = i;
  installedApp.enable = e;
  installedApp.disable = d;
};

function init() {
  if (installedApp.init) {
    installedApp.init();
  }
}
function enable() {
  if (installedApp.enable) {
    installedApp.enable();
  }
}

function disable() {
  if (installedApp.disable) {
    installedApp.disable();
  }
}
 /* Polyfill from Mozilla. */

  // https://tc39.github.io/ecma262/#sec-array.prototype.find
if (!Array.prototype.find && Object.defineProperty) {
  Object.defineProperty(Array.prototype, 'find', {
    value: function(predicate) {
     // 1. Let O be ? ToObject(this value).
      if (this == null) {
        throw new TypeError('"this" is null or not defined');
      }

      var o = Object(this);

      // 2. Let len be ? ToLength(? Get(O, "length")).
      var len = o.length >>> 0;

      // 3. If IsCallable(predicate) is false, throw a TypeError exception.
      if (typeof predicate !== 'function') {
        throw new TypeError('predicate must be a function');
      }

      // 4. If thisArg was supplied, let T be thisArg; else let T be undefined.
      var thisArg = arguments[1];

      // 5. Let k be 0.
      var k = 0;

      // 6. Repeat, while k < len
      while (k < len) {
        // a. Let Pk be ! ToString(k).
        // b. Let kValue be ? Get(O, Pk).
        // c. Let testResult be ToBoolean(? Call(predicate, T, « kValue, k, O »)).
        // d. If testResult is true, return kValue.
        var kValue = o[k];
        if (predicate.call(thisArg, kValue, k, o)) {
          return kValue;
        }
        // e. Increase k by 1.
        k++;
      }

      // 7. Return undefined.
      return undefined;
    }
  });
}

if (!Array.prototype.findIndex && Object.defineProperty) {
  Object.defineProperty(Array.prototype, 'findIndex', {
    value: function(predicate) {
     // 1. Let O be ? ToObject(this value).
      if (this == null) {
        throw new TypeError('"this" is null or not defined');
      }

      var o = Object(this);

      // 2. Let len be ? ToLength(? Get(O, "length")).
      var len = o.length >>> 0;

      // 3. If IsCallable(predicate) is false, throw a TypeError exception.
      if (typeof predicate !== 'function') {
        throw new TypeError('predicate must be a function');
      }

      // 4. If thisArg was supplied, let T be thisArg; else let T be undefined.
      var thisArg = arguments[1];

      // 5. Let k be 0.
      var k = 0;

      // 6. Repeat, while k < len
      while (k < len) {
        // a. Let Pk be ! ToString(k).
        // b. Let kValue be ? Get(O, Pk).
        // c. Let testResult be ToBoolean(? Call(predicate, T, « kValue, k, O »)).
        // d. If testResult is true, return k.
        var kValue = o[k];
        if (predicate.call(thisArg, kValue, k, o)) {
          return k;
        }
        // e. Increase k by 1.
        k++;
      }

      // 7. Return -1.
      return -1;
    }
  });
}
/* Logging
 * Written by Sergey
*/
let debug = false;
/**
 * If called with a false argument, log statements are suppressed.
 */
function setLoggingEnabled(enabled) {
    debug = enabled;
}
/**
 * Log logs the given message using the gnome shell logger (global.log) if the
 * debug variable is set to true.
 *
 * Debug messages may be viewed using the bash command `journalctl
 * /usr/bin/gnome-shell` and grepping the results for 'gTile'.
 */
function log(message) {
    if (debug) {
        global.log("gTile " + message);
    }
}

/* Determine if gnome-shell version newer than required
 * Written by Sergey
*/
function getConfig() {
    return imports.misc.config;
}
const VERSION_34 = { major: 3, minor: 34 };
const VERSION_36 = { major: 3, minor: 36 };
class ShellVersion {
    constructor(version) {
        const parts = version.split('.').map((part) => Number(part));
        if (parts.length < 2) {
            throw new Error(`invalid version supplied: ${version}`);
        }
        this.major = parts[0];
        this.minor = parts[1];
        if (isNaN(this.major) || isNaN(this.minor)) {
            throw new Error(`invalid version supplied: ${version}; got major = ${this.major}, minor = ${this.minor}`);
        }
        this.rawVersion = version;
    }
    static defaultVersion() {
        return new ShellVersion(getConfig().PACKAGE_VERSION);
    }
    static parse(version) {
        return new ShellVersion(version);
    }
    version_at_least_34() {
        return versionGreaterThanOrEqualTo(this, VERSION_34);
    }
    version_at_least_36() {
        return versionGreaterThanOrEqualTo(this, VERSION_36);
    }
    print_version() {
        log("Init gnome-shell version " + this.rawVersion + " major " + this.major + " minor " + this.minor);
    }
}
/**
 * Returns true if a is >= b.
 */
function versionGreaterThanOrEqualTo(a, b) {
    return a.major > b.major || (a.major === b.major && a.minor >= b.minor);
}

// Library imports
const Main = imports.ui.main;
const Meta = imports.gi.Meta;
const Shell = imports.gi.Shell;
// Extension imports
const Me = imports.misc.extensionUtils.getCurrentExtension();
const Settings = Me.imports.settings;
// Globals
const mySettings = Settings.get();
function bind(keyBindings) {
    log("Binding keys");
    for (var key in keyBindings) {
        if (Main.wm.addKeybinding && Shell.ActionMode) { // introduced in 3.16
            Main.wm.addKeybinding(key, mySettings, Meta.KeyBindingFlags.NONE, Shell.ActionMode.NORMAL, keyBindings[key]);
        }
        else if (Main.wm.addKeybinding && Shell.KeyBindingMode) { // introduced in 3.7.5
            Main.wm.addKeybinding(key, mySettings, Meta.KeyBindingFlags.NONE, Shell.KeyBindingMode.NORMAL | Shell.KeyBindingMode.MESSAGE_TRAY, keyBindings[key]);
        }
        else {
            global.display.add_keybinding(key, mySettings, Meta.KeyBindingFlags.NONE, keyBindings[key]);
        }
    }
}
function unbind(keyBindings) {
    log("Unbinding keys");
    for (var key in keyBindings) {
        if (Main.wm.removeKeybinding) { // introduced in 3.7.2
            Main.wm.removeKeybinding(key);
        }
        else {
            global.display.remove_keybinding(key);
        }
    }
}

/* Edited by Sergey after
https://github.com/tpyl/gssnaptoneighbors
 by Timo Pylvanainen <tpyl@iki.fi>
 */
const Meta$1 = imports.gi.Meta;
const WorkspaceManager = global.screen || global.workspace_manager;
const OVERLAP_TOLERANCE = 5;
const SCAN_BOX_SIZE = 50;
/**
 * Return all windows on the currently active workspace
 */
function getWindowsOnActiveWorkspace() {
    let windows = [];
    let windowActors = global.get_window_actors();
    let curWorkSpace = WorkspaceManager.get_active_workspace();
    for (let i = 0; i < windowActors.length; i++) {
        let win = windowActors[i].meta_window;
        if (win.located_on_workspace(curWorkSpace) &&
            !win.minimized &&
            win.get_frame_type() == 0) {
            windows.push(win);
        }
    }
    return windows;
}
/**
 * Find the maximum horzontal expansion from x and
 * returns minx, maxx. The initial maximum x is given
 * as argument, and the expansion is never larger than
 * that.
 *
 * The upper and lower limits define the y coordinate
 * range to check for overlapping windows.
 */
function expandHorizontally(x, upper, lower, minx, maxx, windows) {
    for (let i = 0; i < windows.length; i++) {
        let rect = windows[i].get_frame_rect();
        let wt = rect.y;
        let wb = rect.y + rect.height;
        let wl = rect.x;
        let wr = rect.x + rect.width;
        // Check only  if the window overlaps vertically
        if (wb > upper && wt < lower) {
            if (wr < x && minx < wr) {
                minx = wr;
            }
            if (wl > x && wl < maxx) {
                maxx = wl;
            }
        }
    }
    return { min: minx, max: maxx };
}
/**
 * Find the maximum vertical expansion from  y, and
 * returns miny, maxy. The initial maximum y is given
 * as argument, and the expansion is never larger than
 * that.
 *
 * The left and right limits define the x coordinate
 * range to check for overlapping windows.
 */
function expandVertically(y, left, right, miny, maxy, windows) {
    for (let i = 0; i < windows.length; i++) {
        let rect = windows[i].get_frame_rect();
        let wt = rect.y;
        let wb = rect.y + rect.height;
        let wl = rect.x;
        let wr = rect.x + rect.width;
        // Check only  if the window overlaps horizontally
        if (wr > left && wl < right) {
            if (wb < y && miny < wb) {
                miny = wb;
            }
            if (wt > y && wt < maxy) {
                maxy = wt;
            }
        }
    }
    return { min: miny, max: maxy };
}
/**
 * Resize & move the *window* so it touches adjacent windows or
 * screen edge top, bottom, left and right. The top-left corner
 * of the window defines the expansion point.
 *
 * There is an L-ambiguity where the window could be expanded
 * both vertically and horizontally. The expnasion that results
 * in closer to 1 aspect ratio is selected.
 */
function snapToNeighbors(window) {
    log("snapToNeighbors " + window.get_title());
    // Unmaximize first
    if (window.maximized_horizontally || window.maximized_vertically)
        window.unmaximize(Meta$1.MaximizeFlags.HORIZONTAL | Meta$1.MaximizeFlags.VERTICAL);
    let workArea = window.get_work_area_current_monitor();
    let myrect = window.get_frame_rect();
    let windows = getWindowsOnActiveWorkspace();
    // Scan for overlapping windows in a thin bar around the top of the 
    // window. The vertical height of the window will be adjusted later. 
    let maxHorizw = expandHorizontally(myrect.x + Math.min(SCAN_BOX_SIZE, myrect.width / 2), myrect.y + Math.min(SCAN_BOX_SIZE, myrect.height / 2), myrect.y + Math.min(SCAN_BOX_SIZE, myrect.height / 2) + SCAN_BOX_SIZE, workArea.x, workArea.x + workArea.width, windows);
    let maxHorizh = expandVertically(myrect.y + Math.min(SCAN_BOX_SIZE, myrect.height / 2), maxHorizw.min + OVERLAP_TOLERANCE, maxHorizw.max - OVERLAP_TOLERANCE, workArea.y, workArea.y + workArea.height, windows);
    let maxVerth = expandVertically(myrect.y + Math.min(SCAN_BOX_SIZE, myrect.height / 2), myrect.x + Math.min(SCAN_BOX_SIZE, myrect.width / 2), myrect.x + Math.min(SCAN_BOX_SIZE, myrect.width / 2) + SCAN_BOX_SIZE, workArea.y, workArea.y + workArea.height, windows);
    let maxVertw = expandHorizontally(myrect.x + Math.min(SCAN_BOX_SIZE, myrect.width / 2), maxVerth.min + OVERLAP_TOLERANCE, maxVerth.max - OVERLAP_TOLERANCE, workArea.x, workArea.x + workArea.width, windows);
    if ((maxHorizw.max - maxHorizw.min) * (maxHorizh.max - maxHorizh.min) >
        (maxVertw.max - maxVertw.min) * (maxVerth.max - maxVerth.min)) {
        window.move_resize_frame(true, maxHorizw.min, maxHorizh.min, maxHorizw.max - maxHorizw.min, maxHorizh.max - maxHorizh.min);
    }
    else {
        window.move_resize_frame(true, maxVertw.min, maxVerth.min, maxVertw.max - maxVertw.min, maxVerth.max - maxVerth.min);
    }
}

/*****************************************************************

  This extension has been developed by vibou

  With the help of the gnome-shell community

  Edited by Kvis for gnome 3.8
  Edited by Lundal for gnome 3.18
  Edited by Sergey to add keyboard shortcuts and prefs dialog

 ******************************************************************/
/*****************************************************************
  CONST & VARS
 *****************************************************************/
// Library imports
const St = imports.gi.St;
const Main$1 = imports.ui.main;
const Shell$1 = imports.gi.Shell;
const WindowManager = imports.ui.windowManager;
const MessageTray = imports.ui.messageTray;
const Lang = imports.lang;
const PanelMenu = imports.ui.panelMenu;
const DND = imports.ui.dnd;
const Meta$2 = imports.gi.Meta;
const Clutter = imports.gi.Clutter;
const Signals = imports.signals;
const Workspace = imports.ui.workspace;
// Getter for accesing "get_active_workspace" on GNOME <=2.28 and >= 2.30
const WorkspaceManager$1 = global.screen || global.workspace_manager;
// Extension imports
const Me$1 = imports.misc.extensionUtils.getCurrentExtension();
const Settings$1 = Me$1.imports.settings;
// Globals
const SETTINGS_GRID_SIZES = 'grid-sizes';
const SETTINGS_AUTO_CLOSE = 'auto-close';
const SETTINGS_ANIMATION = 'animation';
const SETTINGS_SHOW_ICON = 'show-icon';
const SETTINGS_GLOBAL_PRESETS = 'global-presets';
const SETTINGS_MOVERESIZE_ENABLED = 'moveresize-enabled';
const SETTINGS_WINDOW_MARGIN = 'window-margin';
const SETTINGS_WINDOW_MARGIN_FULLSCREEN_ENABLED = 'window-margin-fullscreen-enabled';
const SETTINGS_MAX_TIMEOUT = 'max-timeout';
const SETTINGS_INSETS_PRIMARY = 'insets-primary';
const SETTINGS_INSETS_PRIMARY_LEFT = 'insets-primary-left';
const SETTINGS_INSETS_PRIMARY_RIGHT = 'insets-primary-right';
const SETTINGS_INSETS_PRIMARY_TOP = 'insets-primary-top';
const SETTINGS_INSETS_PRIMARY_BOTTOM = 'insets-primary-bottom';
const SETTINGS_INSETS_SECONDARY = 'insets-secondary';
const SETTINGS_INSETS_SECONDARY_LEFT = 'insets-secondary-left';
const SETTINGS_INSETS_SECONDARY_RIGHT = 'insets-secondary-right';
const SETTINGS_INSETS_SECONDARY_TOP = 'insets-secondary-top';
const SETTINGS_INSETS_SECONDARY_BOTTOM = 'insets-secondary-bottom';
const SETTINGS_DEBUG = 'debug';
let status;
let launcher;
let grids;
let tracker;
let nbCols = 0;
let nbRows = 0;
let area;
let focusMetaWindow = false;
let focusConnect = false;
let gridSettings = new Object();
let settings = Settings$1.get();
settings.connect('changed', changed_settings);
let toggleSettingListener;
let keyControlBound = false;
let enabled = false;
const SHELL_VERSION = ShellVersion.defaultVersion();
let presetState = new Array();
presetState["current_variant"] = 0;
presetState["last_call"] = '';
presetState["last_grid_format"] = '';
presetState["last_preset"] = '';
presetState["last_window_title"] = '';
// Hangouts workaround
let excludedApplications = new Array("Unknown");
const keyBindings = {
    'show-toggle-tiling': function () { toggleTiling(); },
    'show-toggle-tiling-alt': function () { toggleTiling(); }
};
const key_bindings_tiling = {
    'move-left': function () { keyMoveResizeEvent('move', 'left'); },
    'move-right': function () { keyMoveResizeEvent('move', 'right'); },
    'move-up': function () { keyMoveResizeEvent('move', 'up'); },
    'move-down': function () { keyMoveResizeEvent('move', 'down'); },
    'resize-left': function () { keyMoveResizeEvent('resize', 'left'); },
    'resize-right': function () { keyMoveResizeEvent('resize', 'right'); },
    'resize-up': function () { keyMoveResizeEvent('resize', 'up'); },
    'resize-down': function () { keyMoveResizeEvent('resize', 'down'); },
    'move-left-vi': function () { keyMoveResizeEvent('move', 'left'); },
    'move-right-vi': function () { keyMoveResizeEvent('move', 'right'); },
    'move-up-vi': function () { keyMoveResizeEvent('move', 'up'); },
    'move-down-vi': function () { keyMoveResizeEvent('move', 'down'); },
    'resize-left-vi': function () { keyMoveResizeEvent('resize', 'left'); },
    'resize-right-vi': function () { keyMoveResizeEvent('resize', 'right'); },
    'resize-up-vi': function () { keyMoveResizeEvent('resize', 'up'); },
    'resize-down-vi': function () { keyMoveResizeEvent('resize', 'down'); },
    'cancel-tiling': function () { keyCancelTiling(); },
    'set-tiling': function () { keySetTiling(); },
    'change-grid-size': function () { keyChangeTiling(); },
    'autotile-main': function () { AutoTileMain(); },
    'autotile-1': function () { AutoTileNCols(1); },
    'autotile-2': function () { AutoTileNCols(2); },
    'autotile-3': function () { AutoTileNCols(3); },
    'autotile-4': function () { AutoTileNCols(4); },
    'autotile-5': function () { AutoTileNCols(5); },
    'autotile-6': function () { AutoTileNCols(6); },
    'autotile-7': function () { AutoTileNCols(7); },
    'autotile-8': function () { AutoTileNCols(8); },
    'autotile-9': function () { AutoTileNCols(9); },
    'autotile-10': function () { AutoTileNCols(10); },
    'snap-to-neighbors': function () { SnapToNeighborsBind(); }
};
const key_bindings_presets = {
    'preset-resize-1': function () { presetResize(1); },
    'preset-resize-2': function () { presetResize(2); },
    'preset-resize-3': function () { presetResize(3); },
    'preset-resize-4': function () { presetResize(4); },
    'preset-resize-5': function () { presetResize(5); },
    'preset-resize-6': function () { presetResize(6); },
    'preset-resize-7': function () { presetResize(7); },
    'preset-resize-8': function () { presetResize(8); },
    'preset-resize-9': function () { presetResize(9); },
    'preset-resize-10': function () { presetResize(10); },
    'preset-resize-11': function () { presetResize(11); },
    'preset-resize-12': function () { presetResize(12); },
    'preset-resize-13': function () { presetResize(13); },
    'preset-resize-14': function () { presetResize(14); },
    'preset-resize-15': function () { presetResize(15); },
    'preset-resize-16': function () { presetResize(16); },
    'preset-resize-17': function () { presetResize(17); },
    'preset-resize-18': function () { presetResize(18); },
    'preset-resize-19': function () { presetResize(19); },
    'preset-resize-20': function () { presetResize(20); },
    'preset-resize-21': function () { presetResize(21); },
    'preset-resize-22': function () { presetResize(22); },
    'preset-resize-23': function () { presetResize(23); },
    'preset-resize-24': function () { presetResize(24); },
    'preset-resize-25': function () { presetResize(25); },
    'preset-resize-26': function () { presetResize(26); },
    'preset-resize-27': function () { presetResize(27); },
    'preset-resize-28': function () { presetResize(28); },
    'preset-resize-29': function () { presetResize(29); },
    'preset-resize-30': function () { presetResize(30); }
};
const key_binding_global_resizes = {
    'action-change-tiling': function () { keyChangeTiling(); },
    'action-contract-bottom': function () { keyMoveResizeEvent('contract', 'bottom', true); },
    'action-contract-left': function () { keyMoveResizeEvent('contract', 'left', true); },
    'action-contract-right': function () { keyMoveResizeEvent('contract', 'right', true); },
    'action-contract-top': function () { keyMoveResizeEvent('contract', 'top', true); },
    'action-expand-bottom': function () { keyMoveResizeEvent('expand', 'bottom', true); },
    'action-expand-left': function () { keyMoveResizeEvent('expand', 'left', true); },
    'action-expand-right': function () { keyMoveResizeEvent('expand', 'right', true); },
    'action-expand-top': function () { keyMoveResizeEvent('expand', 'top', true); },
    'action-move-down': function () { keyMoveResizeEvent('move', 'down', true); },
    'action-move-left': function () { keyMoveResizeEvent('move', 'left', true); },
    'action-move-right': function () { keyMoveResizeEvent('move', 'right', true); },
    'action-move-up': function () { keyMoveResizeEvent('move', 'up', true); }
};
function changed_settings() {
    log("changed_settings");
    if (enabled) {
        disable();
        enable();
    }
    log("changed_settings complete");
}
const GTileStatusButton = new Lang.Class({
    Name: 'GTileStatusButton',
    Extends: PanelMenu.Button,
    _init: function (classname) {
        this.parent(0.0, "gTile", false);
        //Done by default in PanelMenuButton - Just need to override the method
        if (SHELL_VERSION.version_at_least_34()) {
            this.add_style_class_name(classname);
            this.connect('button-press-event', Lang.bind(this, this._onButtonPress));
        }
        else {
            this.actor.add_style_class_name(classname);
            this.actor.connect('button-press-event', Lang.bind(this, this._onButtonPress));
        }
        log("GTileStatusButton _init done");
    },
    reset: function () {
        this.activated = false;
        if (SHELL_VERSION.version_at_least_34()) {
            this.remove_style_pseudo_class('activate');
        }
        else {
            this.actor.remove_style_pseudo_class('activate');
        }
    },
    activate: function () {
        if (SHELL_VERSION.version_at_least_34()) {
            this.add_style_pseudo_class('activate');
        }
        else {
            this.actor.add_style_pseudo_class('activate');
        }
    },
    deactivate: function () {
        if (SHELL_VERSION.version_at_least_34()) {
            this.remove_style_pseudo_class('activate');
        }
        else {
            this.actor.remove_style_pseudo_class('activate');
        }
    },
    _onButtonPress: function (actor, event) {
        log("_onButtonPress Click Toggle Status on system panel");
        toggleTiling();
    },
    _destroy: function () {
        this.activated = null;
    }
});
/*****************************************************************
  SETTINGS
 *****************************************************************/
function parseTuple(format, delimiter) {
    // parsing grid size in format XdelimY, like 6x4 or 1:2
    let gssk = format.trim().split(delimiter);
    if (gssk.length != 2
        || isNaN(gssk[0]) || gssk[0] < 0 || gssk[0] > 99
        || isNaN(gssk[1]) || gssk[1] < 0 || gssk[1] > 99) {
        log("Bad format " + format + ", delimiter " + delimiter);
        return { X: Number(-1), Y: Number(-1) };
    }
    return { X: Number(gssk[0]), Y: Number(gssk[1]) };
}
function initGridSizes(grid_sizes) {
    gridSettings[SETTINGS_GRID_SIZES] = [
        new GridSettingsButton('8x6', 8, 6),
        new GridSettingsButton('6x4', 6, 4),
        new GridSettingsButton('4x4', 4, 4),
    ];
    let grid_sizes_orig = true;
    let gss = grid_sizes.split(",");
    for (var key in gss) {
        let grid_format = parseTuple(gss[key], "x");
        if (grid_format.X == -1) {
            continue;
        }
        if (grid_sizes_orig) {
            gridSettings[SETTINGS_GRID_SIZES] = [];
            grid_sizes_orig = false;
        }
        gridSettings[SETTINGS_GRID_SIZES].push(new GridSettingsButton(grid_format.X + "x" + grid_format.Y, grid_format.X, grid_format.Y));
    }
}
function getBoolSetting(settingName) {
    const value = settings.get_boolean(settingName);
    if (value === undefined) {
        log("Undefined settings " + settingName);
        gridSettings[settingName] = false;
        return false;
    }
    else {
        gridSettings[settingName] = value;
    }
    return value;
}
function getIntSetting(settings_string) {
    let iss = settings.get_int(settings_string);
    if (iss === undefined) {
        log("Undefined settings " + settings_string);
        return 0;
    }
    else {
        return iss;
    }
}
function initSettings() {
    log("Init settings");
    let gridSizes = settings.get_string(SETTINGS_GRID_SIZES);
    log(SETTINGS_GRID_SIZES + " set to " + gridSizes);
    initGridSizes(gridSizes);
    getBoolSetting(SETTINGS_AUTO_CLOSE);
    getBoolSetting(SETTINGS_ANIMATION);
    getBoolSetting(SETTINGS_SHOW_ICON);
    getBoolSetting(SETTINGS_GLOBAL_PRESETS);
    getBoolSetting(SETTINGS_MOVERESIZE_ENABLED);
    gridSettings[SETTINGS_WINDOW_MARGIN] = getIntSetting(SETTINGS_WINDOW_MARGIN);
    gridSettings[SETTINGS_WINDOW_MARGIN_FULLSCREEN_ENABLED] = getBoolSetting(SETTINGS_WINDOW_MARGIN_FULLSCREEN_ENABLED);
    gridSettings[SETTINGS_INSETS_PRIMARY] =
        { top: getIntSetting(SETTINGS_INSETS_PRIMARY_TOP),
            bottom: getIntSetting(SETTINGS_INSETS_PRIMARY_BOTTOM),
            left: getIntSetting(SETTINGS_INSETS_PRIMARY_LEFT),
            right: getIntSetting(SETTINGS_INSETS_PRIMARY_RIGHT) }; // Insets on primary monitor
    gridSettings[SETTINGS_INSETS_SECONDARY] =
        { top: getIntSetting(SETTINGS_INSETS_SECONDARY_TOP),
            bottom: getIntSetting(SETTINGS_INSETS_SECONDARY_BOTTOM),
            left: getIntSetting(SETTINGS_INSETS_SECONDARY_LEFT),
            right: getIntSetting(SETTINGS_INSETS_SECONDARY_RIGHT) };
    gridSettings[SETTINGS_MAX_TIMEOUT] = getIntSetting(SETTINGS_MAX_TIMEOUT);
    // initialize these from settings, the first set of sizes
    if (nbCols == 0 || nbRows == 0) {
        nbCols = gridSettings[SETTINGS_GRID_SIZES][0].cols;
        nbRows = gridSettings[SETTINGS_GRID_SIZES][0].rows;
    }
}
function enable() {
    setLoggingEnabled(getBoolSetting(SETTINGS_DEBUG));
    log("Enabling begin");
    SHELL_VERSION.print_version();
    status = false;
    tracker = Shell$1.WindowTracker.get_default();
    initSettings();
    log("Starting...");
    area = new St.BoxLayout({ style_class: 'grid-preview' });
    Main$1.uiGroup.add_actor(area);
    initGrids();
    log("Create Button");
    launcher = new GTileStatusButton('tiling-icon');
    if (gridSettings[SETTINGS_SHOW_ICON]) {
        Main$1.panel.addToStatusArea("GTileStatusButton", launcher);
    }
    bind(keyBindings);
    if (gridSettings[SETTINGS_GLOBAL_PRESETS]) {
        bind(key_bindings_presets);
    }
    if (gridSettings[SETTINGS_MOVERESIZE_ENABLED]) {
        bind(key_binding_global_resizes);
    }
    Main$1.layoutManager.connect('monitors-changed', () => {
        log("Reinitializing grids on monitors-changed");
        destroyGrids();
        initGrids();
    });
    enabled = true;
    log("Extention Enabled!");
}
function disable() {
    log("Extension start disabling");
    enabled = false;
    Main$1.layoutManager.disconnect('monitors-changed');
    unbind(keyBindings);
    unbind(key_bindings_presets);
    unbind(key_binding_global_resizes);
    if (keyControlBound) {
        unbind(key_bindings_tiling);
        keyControlBound = false;
    }
    launcher.destroy();
    launcher = null;
    destroyGrids();
    resetFocusMetaWindow();
    log("Extention Disabled!");
}
function resetFocusMetaWindow() {
    log("resetFocusMetaWindow");
    focusMetaWindow = false;
}
function initGrids() {
    log("initGrids");
    grids = new Array();
    const monitors = activeMonitors();
    for (let monitorIdx = 0; monitorIdx < monitors.length; monitorIdx++) {
        log("New Grid for monitor " + monitorIdx);
        let monitor = monitors[monitorIdx];
        let grid = new Grid(monitorIdx, monitor, "gTile", nbCols, nbRows);
        let key = getMonitorKey(monitor);
        grids[key] = grid;
        Main$1.layoutManager.addChrome(grid.actor, { trackFullscreen: true });
        grid.actor.set_opacity(0);
        grid.hide(true);
        log("Connect hide-tiling for monitor " + monitorIdx);
        grid.connectHideTiling = grid.connect('hide-tiling', hideTiling);
    }
    log("Init grid done");
}
function destroyGrids() {
    log("destroyGrids");
    for (let grid of grids) {
        grid.hide(true);
        Main$1.layoutManager.removeChrome(grid.actor);
    }
    log("destroyGrids done");
}
function refreshGrids() {
    log("refreshGrids");
    for (let grid of grids) {
        grid.refresh();
    }
    log("refreshGrids done");
}
function moveGrids() {
    log("moveGrids");
    if (!status) {
        return;
    }
    let window = focusMetaWindow;
    if (window) {
        for (var gridIdx in grids) {
            let grid = grids[gridIdx];
            let pos_x;
            let pos_y;
            let monitor = grid.monitor;
            if (window.get_monitor() == grid.monitor_idx) {
                pos_x = window.get_frame_rect().width / 2 + window.get_frame_rect().x;
                pos_y = window.get_frame_rect().height / 2 + window.get_frame_rect().y;
                let [mouse_x, mouse_y, mask] = global.get_pointer();
                let act_x = pos_x - grid.actor.width / 2;
                let act_y = pos_y - grid.actor.height / 2;
                if (mouse_x >= act_x
                    && mouse_x <= act_x + grid.actor.width
                    && mouse_y >= act_y
                    && mouse_y <= act_y + grid.actor.height) {
                    log("Mouse x " + mouse_x + " y " + mouse_y +
                        " is inside grid actor rectangle, changing actor X from " + pos_x + " to " + (mouse_x + grid.actor.width / 2) +
                        ", Y from " + pos_y + " to " + (mouse_y + grid.actor.height / 2));
                    pos_x = mouse_x + grid.actor.width / 2;
                    pos_y = mouse_y + grid.actor.height / 2;
                }
            }
            else {
                pos_x = monitor.x + monitor.width / 2;
                pos_y = monitor.y + monitor.height / 2;
            }
            pos_x = Math.floor(pos_x - grid.actor.width / 2);
            pos_y = Math.floor(pos_y - grid.actor.height / 2);
            if (window.get_monitor() == grid.monitor_idx) {
                pos_x = (pos_x < monitor.x) ? monitor.x : pos_x;
                pos_x = ((pos_x + grid.actor.width) > (monitor.width + monitor.x)) ? monitor.x + monitor.width - grid.actor.width : pos_x;
                pos_y = (pos_y < monitor.y) ? monitor.y : pos_y;
                pos_y = ((pos_y + grid.actor.height) > (monitor.height + monitor.y)) ? monitor.y + monitor.height - grid.actor.height : pos_y;
            }
            let time = (gridSettings[SETTINGS_ANIMATION]) ? 0.3 : 0.1;
            grid.actor.ease({
                time: time,
                x: pos_x,
                y: pos_y,
                transition: Clutter.AnimationMode.EASE_OUT_QUAD,
            });
        }
    }
}
function updateRegions() {
    /*Main.layoutManager._chrome.updateRegions();*/
    log("updateRegions");
    refreshGrids();
    for (let idx in grids) {
        let grid = grids[idx];
        grid.elementsDelegate.reset();
    }
}
function reset_window(metaWindow) {
    metaWindow.unmaximize(Meta$2.MaximizeFlags.HORIZONTAL);
    metaWindow.unmaximize(Meta$2.MaximizeFlags.VERTICAL);
    metaWindow.unmaximize(Meta$2.MaximizeFlags.HORIZONTAL | Meta$2.MaximizeFlags.VERTICAL);
}
function _getInvisibleBorderPadding(metaWindow) {
    let outerRect = metaWindow.get_frame_rect();
    let inputRect = metaWindow.get_buffer_rect();
    let borderX = outerRect.x - inputRect.x;
    let borderY = outerRect.y - inputRect.y;
    return [borderX, borderY];
}
function _getVisibleBorderPadding(metaWindow) {
    let clientRect = metaWindow.get_frame_rect();
    let outerRect = metaWindow.get_frame_rect();
    let borderX = outerRect.width - clientRect.width;
    let borderY = outerRect.height - clientRect.height;
    return [borderX, borderY];
}
function move_maximize_window(metaWindow, x, y) {
    let borderX, borderY;
    [borderX, borderY] = _getInvisibleBorderPadding(metaWindow);
    x = x - borderX;
    y = y - borderY;
    metaWindow.move_frame(true, x, y);
    metaWindow.maximize(Meta$2.MaximizeFlags.HORIZONTAL | Meta$2.MaximizeFlags.VERTICAL);
}
/**
 * Resizes window considering margin settings
 * @param metaWindow
 * @param x
 * @param y
 * @param width
 * @param height
 */
function move_resize_window_with_margins(metaWindow, x, y, width, height) {
    let [borderX, borderY] = _getInvisibleBorderPadding(metaWindow);
    let [vBorderX, vBorderY] = _getVisibleBorderPadding(metaWindow);
    log("move_resize_window_with_margins " + metaWindow.get_title() + " " + x + ":" + y + " - " + width
        + ":" + height + " margin " + gridSettings[SETTINGS_WINDOW_MARGIN] + " borders invisible " +
        borderX + ":" + borderY + " visible " + vBorderX + ":" + vBorderY);
    x = x + gridSettings[SETTINGS_WINDOW_MARGIN];
    y = y + gridSettings[SETTINGS_WINDOW_MARGIN];
    width = width - gridSettings[SETTINGS_WINDOW_MARGIN] * 2;
    height = height - gridSettings[SETTINGS_WINDOW_MARGIN] * 2;
    x = x + vBorderX;
    y = y + vBorderY;
    width = width - 2 * vBorderX;
    height = height - 2 * vBorderY;
    log("After margins and visible border window is " + x + ":" + y + " - " + width + ":" + height);
    metaWindow.move_resize_frame(true, x, y, width, height);
}
function getNotFocusedWindowsOfMonitor(monitor) {
    const monitors = activeMonitors();
    let windows = global.get_window_actors().filter(function (w) {
        let app = tracker.get_window_app(w.meta_window);
        if (app == null) {
            return false;
        }
        let appName = app.get_name();
        return !contains(excludedApplications, appName)
            && w.meta_window.get_window_type() == Meta$2.WindowType.NORMAL
            && w.meta_window.get_workspace() == WorkspaceManager$1.get_active_workspace()
            && w.meta_window.showing_on_its_workspace()
            && monitors[w.meta_window.get_monitor()] == monitor
            && focusMetaWindow != w.meta_window;
    });
    return windows;
}
function _onFocus() {
    log("_onFocus ");
    resetFocusMetaWindow();
    let window = getFocusApp();
    if (window && status) {
        log("_onFocus " + window.get_title());
        focusMetaWindow = window;
        let app = tracker.get_window_app(focusMetaWindow);
        let title = focusMetaWindow.get_title();
        const monitors = activeMonitors();
        for (let monitorIdx = 0; monitorIdx < monitors.length; monitorIdx++) {
            let monitor = monitors[monitorIdx];
            let key = getMonitorKey(monitor);
            let grid = grids[key];
            if (app) {
                grid.topbar._set_app(app, title);
            }
            else {
                grid.topbar._set_title(title);
            }
        }
        moveGrids();
    }
    else {
        if (status) {
            log("No focus window, hide tiling");
            hideTiling();
        }
        else {
            log("tiling window not active");
        }
    }
}
function showTiling() {
    log("showTiling");
    focusMetaWindow = getFocusApp();
    if (!focusMetaWindow) {
        log("No focus window");
        return;
    }
    let wm_type = focusMetaWindow.get_window_type();
    let layer = focusMetaWindow.get_layer();
    area.visible = true;
    if (focusMetaWindow && wm_type != 1 && layer > 0) {
        const monitors = activeMonitors();
        for (let monitorIdx = 0; monitorIdx < monitors.length; monitorIdx++) {
            let monitor = monitors[monitorIdx];
            let key = getMonitorKey(monitor);
            let grid = grids[key];
            let window = getFocusApp();
            let pos_x;
            let pos_y;
            if (window.get_monitor() == monitorIdx) {
                pos_x = window.get_frame_rect().width / 2 + window.get_frame_rect().x;
                pos_y = window.get_frame_rect().height / 2 + window.get_frame_rect().y;
                let [mouse_x, mouse_y, mask] = global.get_pointer();
                let act_x = pos_x - grid.actor.width / 2;
                let act_y = pos_y - grid.actor.height / 2;
                if (mouse_x >= act_x
                    && mouse_x <= act_x + grid.actor.width
                    && mouse_y >= act_y
                    && mouse_y <= act_y + grid.actor.height) {
                    log("Mouse x " + mouse_x + " y " + mouse_y +
                        " is inside grid actor rectangle, changing actor X from " + pos_x + " to " + (mouse_x + grid.actor.width / 2) +
                        ", Y from " + pos_y + " to " + (mouse_y + grid.actor.height / 2));
                    pos_x = mouse_x + grid.actor.width / 2;
                    pos_y = mouse_y + grid.actor.height / 2;
                }
            }
            else {
                pos_x = monitor.x + monitor.width / 2;
                pos_y = monitor.y + monitor.height / 2;
            }
            grid.set_position(Math.floor(pos_x - grid.actor.width / 2), Math.floor(pos_y - grid.actor.height / 2));
            grid.show();
        }
        status = true;
        _onFocus();
        launcher.activate();
        bindKeyControls();
    }
    moveGrids();
}
function hideTiling() {
    log("hideTiling");
    for (let gridIdx in grids) {
        let grid = grids[gridIdx];
        grid.elementsDelegate.reset();
        grid.hide(false);
    }
    area.visible = false;
    resetFocusMetaWindow();
    launcher.deactivate();
    status = false;
    unbindKeyControls();
}
function toggleTiling() {
    if (status) {
        hideTiling();
    }
    else {
        showTiling();
    }
    return status;
}
function getMonitorKey(monitor) {
    return monitor.x + ":" + monitor.width + ":" + monitor.y + ":" + monitor.height;
}
function contains(a, obj) {
    var i = a.length;
    while (i--) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
}
/**
 * Get focused window by iterating though the windows on the active workspace.
 * @returns {Object} The focussed window object. False if no focussed window was found.
 */
function getFocusApp() {
    if (tracker.focus_app == null) {
        return false;
    }
    let focusedAppName = tracker.focus_app.get_name();
    if (contains(excludedApplications, focusedAppName)) {
        return false;
    }
    let windows = WorkspaceManager$1.get_active_workspace().list_windows();
    let focusedWindow = false;
    for (let i = 0; i < windows.length; ++i) {
        let metaWindow = windows[i];
        if (metaWindow.has_focus()) {
            focusedWindow = metaWindow;
            break;
        }
    }
    return focusedWindow;
}
function activeMonitors() {
    return Main$1.layoutManager.monitors;
}
/**
 * Determine if the given monitor is the primary monitor.
 * @param {Object} monitor The given monitor to evaluate.
 * @returns {boolean} True if the given monitor is the primary monitor.
 * */
function isPrimaryMonitor(monitor) {
    return Main$1.layoutManager.primaryMonitor.x == monitor.x && Main$1.layoutManager.primaryMonitor.y == monitor.y;
}
function getWorkAreaByMonitor(monitor) {
    const monitors = activeMonitors();
    for (let monitor_idx = 0; monitor_idx < monitors.length; monitor_idx++) {
        let mon = monitors[monitor_idx];
        if (mon.x == monitor.x && mon.y == monitor.y) {
            return getWorkArea(monitor, monitor_idx);
        }
    }
    return null;
}
function getWorkAreaByMonitorIdx(monitor_idx) {
    const monitors = activeMonitors();
    let monitor = monitors[monitor_idx];
    return getWorkArea(monitor, monitor_idx);
}
function getWorkArea(monitor, monitor_idx) {
    const wkspace = WorkspaceManager$1.get_active_workspace();
    const work_area = wkspace.get_work_area_for_monitor(monitor_idx);
    const insets = (isPrimaryMonitor(monitor)) ? gridSettings[SETTINGS_INSETS_PRIMARY] : gridSettings[SETTINGS_INSETS_SECONDARY];
    return {
        x: work_area.x + insets.left,
        y: work_area.y + insets.top,
        width: work_area.width - insets.left - insets.right,
        height: work_area.height - insets.top - insets.bottom
    };
}
function bindKeyControls() {
    if (!keyControlBound) {
        bind(key_bindings_tiling);
        if (focusConnect) {
            global.display.disconnect(focusConnect);
        }
        focusConnect = global.display.connect('notify::focus-window', _onFocus);
        if (!gridSettings[SETTINGS_GLOBAL_PRESETS]) {
            bind(key_bindings_presets);
        }
        keyControlBound = true;
    }
}
function unbindKeyControls() {
    if (keyControlBound) {
        unbind(key_bindings_tiling);
        if (focusConnect) {
            log("Disconnect notify:focus-window");
            global.display.disconnect(focusConnect);
            focusConnect = false;
        }
        if (!gridSettings[SETTINGS_GLOBAL_PRESETS]) {
            unbind(key_bindings_presets);
        }
        if (!gridSettings[SETTINGS_MOVERESIZE_ENABLED]) {
            unbind(key_binding_global_resizes);
        }
        keyControlBound = false;
    }
}
function keyCancelTiling() {
    log("Cancel key event");
    hideTiling();
}
function keySetTiling() {
    log("keySetTiling");
    if (focusMetaWindow) {
        const monitors = activeMonitors();
        let mind = focusMetaWindow.get_monitor();
        let monitor = monitors[mind];
        let mkey = getMonitorKey(monitor);
        let grid = grids[mkey];
        log("In grid " + grid);
        if (grid.elementsDelegate.currentElement) {
            grid.elementsDelegate.currentElement._onButtonPress();
        }
    }
}
function keyChangeTiling() {
    log("keyChangeTiling");
    let grid_settings_sizes = gridSettings[SETTINGS_GRID_SIZES];
    let next_key = 0;
    let found = false;
    for (let key in grid_settings_sizes) {
        if (found) {
            next_key = key;
            break;
        }
        log("Checking grid settings size " + key + " have cols " + grid_settings_sizes[key].cols + " and rows " + grid_settings_sizes[key].rows);
        if (grid_settings_sizes[key].cols == nbCols && grid_settings_sizes[key].rows == nbRows) {
            found = true;
        }
    }
    log("found matching grid nbCols " + nbCols + " nbRows " + nbRows + " next key is " + next_key);
    log("New settings will be nbCols " + grid_settings_sizes[next_key].cols + " nbRows " + grid_settings_sizes[next_key].rows);
    grid_settings_sizes[next_key]._onButtonPress();
    log("New settings are nbCols " + nbCols + " nbRows " + nbRows);
    setInitialSelection();
}
function setInitialSelection() {
    if (!focusMetaWindow) {
        return;
    }
    let mind = focusMetaWindow.get_monitor();
    const monitors = activeMonitors();
    let monitor = monitors[mind];
    let workArea = getWorkArea(monitor, mind);
    let wx = focusMetaWindow.get_frame_rect().x;
    let wy = focusMetaWindow.get_frame_rect().y;
    let wwidth = focusMetaWindow.get_frame_rect().width;
    let wheight = focusMetaWindow.get_frame_rect().height;
    let mkey = getMonitorKey(monitor);
    let grid = grids[mkey];
    let delegate = grid.elementsDelegate;
    log("Set initial selection");
    log("Focus window position x " + wx + " y " + wy + " width " + wwidth + " height " + wheight);
    log("Focus monitor position x " + monitor.x + " y " + monitor.y + " width " + monitor.width + " height " + monitor.height);
    log("Workarea position x " + workArea.x + " y " + workArea.y + " width " + workArea.width + " height " + workArea.height);
    let wax = Math.max(wx - workArea.x, 0);
    let way = Math.max(wy - workArea.y, 0);
    let grid_element_width = workArea.width / nbCols;
    let grid_element_height = workArea.height / nbRows;
    log("width " + grid_element_width + " height " + grid_element_height);
    let lux = Math.min(Math.max(Math.round(wax / grid_element_width), 0), nbCols - 1);
    log("wx " + (wx - workArea.x) + " el_width " + grid_element_width + " max " + (nbCols - 1) + " res " + lux);
    let luy = Math.min(Math.max(Math.round(way / grid_element_height), 0), grid.rows - 1);
    log("wy " + (wy - workArea.y) + " el_height " + grid_element_height + " max " + (nbRows - 1) + " res " + luy);
    let rdx = Math.min(Math.max(Math.round((wax + wwidth) / grid_element_width) - 1, lux), grid.cols - 1);
    log("wx + wwidth " + (wx + wwidth - workArea.x - 1) + " el_width " + grid_element_width + " max " + (nbCols - 1) + " res " + rdx);
    let rdy = Math.min(Math.max(Math.round((way + wheight) / grid_element_height) - 1, luy), grid.rows - 1);
    log("wy + wheight " + (wy + wheight - workArea.y - 1) + " el_height " + grid_element_height + " max " + (nbRows - 1) + " res " + rdy);
    log("Initial tile selection is " + lux + ":" + luy + " - " + rdx + ":" + rdy);
    grid.forceGridElementDelegate(lux, luy, rdx, rdy);
    grid.elements[luy][lux]._onButtonPress();
    grid.elements[rdy][rdx]._onHoverChanged();
    let cX = delegate.currentElement.coordx;
    let cY = delegate.currentElement.coordy;
    let fX = delegate.first.coordx;
    let fY = delegate.first.coordy;
    log("After initial selection first fX " + fX + " fY " + fY + " current cX " + cX + " cY " + cY);
}
function keyMoveResizeEvent(type, key, is_global = false) {
    if (is_global) {
        focusMetaWindow = getFocusApp();
    }
    log("Got key event " + type + " " + key);
    if (!focusMetaWindow) {
        return;
    }
    log("Going on..");
    let mind = focusMetaWindow.get_monitor();
    const monitors = activeMonitors();
    let monitor = monitors[mind];
    let mkey = getMonitorKey(monitor);
    let grid = grids[mkey];
    let delegate = grid.elementsDelegate;
    if (!delegate.currentElement) {
        log("Key event while no mouse activation - set current and second element");
        setInitialSelection();
    }
    else {
        if (!delegate.first) {
            log("currentElement is there but no first yet");
            delegate.currentElement._onButtonPress();
        }
    }
    if (!delegate.currentElement) {
        log("gTime currentElement is not set!");
    }
    let cX = delegate.currentElement.coordx;
    let cY = delegate.currentElement.coordy;
    let fX = delegate.first.coordx;
    let fY = delegate.first.coordy;
    log("Before move/resize first fX " + fX + " fY " + fY + " current cX " + cX + " cY " + cY);
    log("Grid cols " + nbCols + " rows " + nbRows);
    if (type == 'move') {
        switch (key) {
            case 'right':
                if (fX < nbCols - 1 && cX < nbCols - 1) {
                    delegate.first = grid.elements[fY][fX + 1];
                    grid.elements[cY][cX + 1]._onHoverChanged();
                }
                break;
            case 'left':
                if (fX > 0 && cX > 0) {
                    delegate.first = grid.elements[fY][fX - 1];
                    grid.elements[cY][cX - 1]._onHoverChanged();
                }
                break;
            case 'up':
                if (fY > 0 && cY > 0) {
                    delegate.first = grid.elements[fY - 1][fX];
                    grid.elements[cY - 1][cX]._onHoverChanged();
                }
                break;
            case 'down':
                if (fY < nbRows - 1 && cY < nbRows - 1) {
                    delegate.first = grid.elements[fY + 1][fX];
                    grid.elements[cY + 1][cX]._onHoverChanged();
                }
                break;
        }
    }
    else if (type == "resize") {
        switch (key) {
            case 'right':
                if (cX < nbCols - 1) {
                    grid.elements[cY][cX + 1]._onHoverChanged();
                }
                break;
            case 'left':
                if (cX > 0) {
                    grid.elements[cY][cX - 1]._onHoverChanged();
                }
                break;
            case 'up':
                if (cY > 0) {
                    grid.elements[cY - 1][cX]._onHoverChanged();
                }
                break;
            case 'down':
                if (cY < nbRows - 1) {
                    grid.elements[cY + 1][cX]._onHoverChanged();
                }
                break;
        }
    }
    else if (type == "contract") {
        switch (key) {
            case 'left':
                // Contract left edge of current window right one column
                if (cX > fX) {
                    delegate.first = grid.elements[fY][fX + 1];
                }
                break;
            case 'right':
                // Contract right edge of current window left one column
                if (cX > fX) {
                    grid.elements[cY][cX - 1]._onHoverChanged();
                }
                break;
            case 'top':
                // Contract top edge of current window down one row
                if (cY > fY) {
                    delegate.first = grid.elements[fY + 1][fX];
                }
                break;
            case 'bottom':
                // Contract bottom edge of current window up one row
                if (cY > fY) {
                    grid.elements[cY - 1][cX]._onHoverChanged();
                }
                break;
        }
    }
    else if (type == "expand") {
        switch (key) {
            case 'right':
                if (cX < nbCols) {
                    grid.elements[cY][cX + 1]._onHoverChanged();
                }
                break;
            case 'left':
                if (fX > 0) {
                    delegate.first = grid.elements[fY][fX - 1];
                }
                break;
            case 'top':
                if (fY > 0) {
                    delegate.first = grid.elements[fY - 1][fX];
                }
                break;
            case 'bottom':
                if (cY < nbRows - 1) {
                    grid.elements[cY + 1][cX]._onHoverChanged();
                }
                break;
        }
    }
    cX = delegate.currentElement.coordx;
    cY = delegate.currentElement.coordy;
    fX = delegate.first.coordx;
    fY = delegate.first.coordy;
    log("After move/resize first fX " + fX + " fY " + fY + " current cX " + cX + " cY " + cY);
    if (is_global) {
        keySetTiling();
    }
}
/**
 * Resize window to the given preset.
 * @param  {number}  Identifier of the resize preset (1 - 30)
 */
function presetResize(preset) {
    // Check if there's a focusable window
    let window = getFocusApp();
    if (!window) {
        log("No focused window - ignoring keyboard shortcut");
        return;
    }
    // Lets assume window titles are always unique.
    // Note: window roles 'window.get_role()' would offer a unique identifier.
    // Unfortunately role is often set to NULL.
    log("presetResize window title: " + window.get_title());
    // Ensure that the window is not maximized
    reset_window(window);
    // Fetch, parse and validate the given preset.
    // Expected preset format is "XxY x1:y1 x2:y2[,x1:y1 x2:y2]":
    //  - XxY is grid size like 6x8
    //  - x1:y1 is left upper corner tile coordinates in grid tiles, starting from 0
    //  - x2:y2 is right down corner tile coordinates in grid tiles
    //  - a preset can define multiple variants (e.g. "3x2 0:0 0:1,0:0 1:1,0:0 2:1")
    //  - variants can be activated using the same shortcut consecutively
    let preset_string = settings.get_string("resize" + preset);
    log("Preset resize " + preset + "  is " + preset_string);
    let ps_variants = preset_string.split(",");
    // retrieve and validate preset string / first preset variant
    let ps = ps_variants[0].trim().split(" ");
    if (ps.length != 3) {
        log("Bad preset " + preset + " settings " + preset_string);
        return;
    }
    // parse the preset string (grid size, left-upper-corner, right-down-corner)
    let grid_format = parseTuple(ps[0], "x");
    let luc = parseTuple(ps[1], ":");
    let rdc = parseTuple(ps[2], ":");
    // handle preset variants (if there are any)
    let ps_variant_count = ps_variants.length;
    if (ps_variant_count > 1) {
        if (presetState["last_call"] + gridSettings[SETTINGS_MAX_TIMEOUT] > new Date().getTime() &&
            presetState["last_preset"] == preset &&
            presetState["last_window_title"] == window.get_title()) {
            // within timeout (default: 2s), same preset & same window:
            // increase variant counter, but consider upper boundary
            presetState["current_variant"] = (presetState["current_variant"] + 1) % ps_variant_count;
        }
        else {
            // timeout, new preset or new window:
            // update presetState["last_preset"] and reset variant counter
            presetState["current_variant"] = 0;
        }
    }
    else {
        presetState["current_variant"] = 0;
    }
    // retrieve current preset variant
    if (presetState["current_variant"] > 0) {
        ps = ps_variants[presetState["current_variant"]].trim().split(" ");
        if (ps.length == 3) {
            // handle complete variant definitions
            grid_format = parseTuple(ps[0], "x");
            luc = parseTuple(ps[1], ":");
            rdc = parseTuple(ps[2], ":");
        }
        else if (ps.length == 2) {
            // handle short variant definitions - grid format is taken from
            // a previous variant
            grid_format = presetState["last_grid_format"];
            luc = parseTuple(ps[0], ":");
            rdc = parseTuple(ps[1], ":");
        }
        else {
            log("Bad preset " + preset + " settings " + preset_string);
            return;
        }
    }
    log("Parsed " + grid_format.X + "x" + grid_format.Y + " "
        + luc.X + ":" + luc.Y + " " + rdc.X + ":" + rdc.Y);
    if (grid_format.X < 1 || luc.X < 0 || rdc.X < 0 ||
        grid_format.Y < 1 || luc.Y < 0 || rdc.Y < 0 ||
        grid_format.X <= luc.X || grid_format.X <= rdc.X ||
        grid_format.Y <= luc.Y || grid_format.Y <= rdc.Y ||
        luc.X > rdc.X || luc.Y > rdc.Y) {
        log("Bad preset " + preset + " settings " + preset_string);
        return;
    }
    log("Parsed preset " + preset + " " + grid_format.X + "x" + grid_format.Y +
        " " + luc.X + ":" + luc.Y + " " + rdc.X + ":" + rdc.Y);
    // do the maths to resize the window
    let mind = window.get_monitor();
    let work_area = getWorkAreaByMonitorIdx(mind);
    let grid_element_width = work_area.width / grid_format.X;
    let grid_element_height = work_area.height / grid_format.Y;
    let wx = Math.round(work_area.x + luc.X * grid_element_width);
    let wy = Math.round(work_area.y + luc.Y * grid_element_height);
    let ww = Math.round((rdc.X + 1 - luc.X) * grid_element_width);
    let wh = Math.round((rdc.Y + 1 - luc.Y) * grid_element_height);
    log("Resize preset " + preset + " resizing to wx " + wx + " wy " + wy + " ww " + ww + " wh " + wh);
    move_resize_window_with_margins(window, wx, wy, ww, wh);
    presetState["last_preset"] = preset;
    presetState["last_grid_format"] = grid_format;
    presetState["last_window_title"] = window.get_title();
    presetState["last_call"] = new Date().getTime();
    log("Resize preset last call: " + presetState["last_call"]);
}
/*****************************************************************
  PROTOTYPES
 *****************************************************************/
function TopBar(title) {
    this._init(title);
}
TopBar.prototype = {
    _init: function (title) {
        this.actor = new St.BoxLayout({ style_class: 'top-box' });
        this._title = title;
        this._stlabel = new St.Label({ style_class: 'grid-title', text: this._title });
        this._closebutton = new St.Button({ style_class: 'close-button' });
        this._closebutton.add_style_class_name('close-button-container');
        this._connect_id = this._closebutton.connect('button-press-event', Lang.bind(this, this._onButtonPress));
        this.actor.add_actor(this._closebutton);
        this.actor.add_actor(this._stlabel);
    },
    _set_title: function (title) {
        this._title = title;
        this._stlabel.text = this._title;
    },
    _set_app: function (app, title) {
        this._title = app.get_name() + " - " + title;
        log("title: " + this._title);
        this._stlabel.text = this._title;
    },
    _onButtonPress() {
        log("Close button");
        toggleTiling();
    },
    destroy() {
        this._closebutton.disconnect(this._connect_id);
        super.destroy();
    },
};
function ToggleSettingsButtonListener() {
    this._init();
}
ToggleSettingsButtonListener.prototype = {
    _init: function () {
        this.actors = new Array();
    },
    addActor: function (actor) {
        log("ToggleSettingsButtonListener Connect update-toggle");
        actor.connect('update-toggle', Lang.bind(this, this._updateToggle));
        this.actors.push(actor);
    },
    _updateToggle: function () {
        log("ToggleSettingsButtonListener _updateToggle");
        for (let actorIdx in this.actors) {
            let actor = this.actors[actorIdx];
            actor._update();
        }
    }
};
function ToggleSettingsButton(text, property) {
    this._init(text, property);
}
ToggleSettingsButton.prototype = {
    _init: function (text, property) {
        this.text = text;
        this.actor = new St.Button({
            style_class: 'settings-button',
            reactive: true,
            can_focus: true,
            track_hover: true
        });
        this.label = new St.Label({ style_class: 'settings-label', reactive: true, can_focus: true, track_hover: true, text: this.text });
        this.icon = new St.BoxLayout({ style_class: this.text + "-icon", reactive: true, can_focus: true, track_hover: true });
        this.actor.add_actor(this.icon);
        this.property = property;
        this._update();
        log("ToggleSettingsButton Connect button-press-event");
        this.actor.connect('button-press-event', Lang.bind(this, this._onButtonPress));
        log("ToggleSettingsButton Connect update-toggle");
        this.connect('update-toggle', Lang.bind(this, this._update));
    },
    _update: function () {
        log("ToggleSettingsButton _update event " + this.property);
        if (gridSettings[this.property]) {
            this.actor.add_style_pseudo_class('activate');
        }
        else {
            this.actor.remove_style_pseudo_class('activate');
        }
    },
    _onButtonPress: function () {
        gridSettings[this.property] = !gridSettings[this.property];
        log("ToggleSettingsButton _onButtonPress " + this.property + ": " + gridSettings[this.property] + ", emitting signal update-toggle");
        this.emit('update-toggle');
    }
};
Signals.addSignalMethods(ToggleSettingsButton.prototype);
function ActionButton(grid, classname) {
    this._init(grid, classname);
}
ActionButton.prototype = {
    _init: function (grid, classname) {
        this.grid = grid;
        this.actor = new St.Button({ style_class: 'settings-button',
            reactive: true,
            can_focus: true,
            track_hover: true
        });
        this.icon = new St.BoxLayout({ style_class: classname, reactive: true, can_focus: true, track_hover: true });
        this.actor.add_actor(this.icon);
        log("ActionButton Connect button-press-event");
        this.actor.connect('button-press-event', Lang.bind(this, this._onButtonPress));
    },
    _onButtonPress: function () {
        log("ActionButton _onButtonPress Emitting signal button-press-event");
        this.emit('button-press-event');
    }
};
Signals.addSignalMethods(ActionButton.prototype);
function AutoTileMainAndList(grid) {
    this._init(grid, "action-main-list");
}
AutoTileMainAndList.prototype = {
    __proto__: ActionButton.prototype,
    _init: function (grid, classname) {
        ActionButton.prototype._init.call(this, grid, classname);
        this.classname = classname;
        log("AutoTileMainAndList connect button-press-event");
        this.connect('button-press-event', Lang.bind(this, this._onButtonPress));
    },
    _onButtonPress: function () {
        AutoTileMain();
        log("AutoTileMainAndList _onButtonPress Emitting signal resize-done");
        this.emit('resize-done');
    }
};
Signals.addSignalMethods(AutoTileMainAndList.prototype);
function AutoTileMain() {
    log("AutoTileMain");
    let window = getFocusApp();
    if (!window) {
        log("No focused window - ignoring keyboard shortcut AutoTileMain");
        return;
    }
    reset_window(window);
    let mind = window.get_monitor();
    let work_area = getWorkAreaByMonitorIdx(mind);
    const monitors = activeMonitors();
    let monitor = monitors[mind];
    let workArea = getWorkAreaByMonitor(monitor);
    let notFocusedwindows = getNotFocusedWindowsOfMonitor(monitor);
    if (Object.keys(notFocusedwindows).length === 0) {
        move_resize_window_with_margins(focusMetaWindow, workArea.x, workArea.y, workArea.width, workArea.height);
        return;
    }
    move_resize_window_with_margins(focusMetaWindow, workArea.x, workArea.y, workArea.width / 2, workArea.height);
    let winHeight = workArea.height / notFocusedwindows.length;
    let countWin = 0;
    log("AutoTileMain MonitorHeight: " + monitor.height + ":" + notFocusedwindows.length);
    for (let windowIdx in notFocusedwindows) {
        let metaWindow = notFocusedwindows[windowIdx].meta_window;
        let newOffset = workArea.y + (countWin * winHeight);
        reset_window(metaWindow);
        move_resize_window_with_margins(metaWindow, workArea.x + workArea.width / 2, newOffset, workArea.width / 2, winHeight);
        countWin++;
    }
    log("AutoTileMain done");
}
function AutoTileTwoList(grid) {
    this._init(grid, "action-two-list");
}
AutoTileTwoList.prototype = {
    __proto__: ActionButton.prototype,
    _init: function (grid, classname) {
        ActionButton.prototype._init.call(this, grid, classname);
        this.classname = classname;
        log("AutoTileTwoList connect button-press-event");
        this.connect('button-press-event', Lang.bind(this, this._onButtonPress));
    },
    _onButtonPress: function () {
        log("AutotileTwoList");
        AutoTileNCols(2);
        log("AutoTileTwoList _onButtonPress Emitting signal resize-done");
        this.emit('resize-done');
        log("Autotile2 done");
    }
};
Signals.addSignalMethods(AutoTileTwoList.prototype);
function AutoTileNCols(cols) {
    log("AutoTileNCols " + cols);
    let window = getFocusApp();
    if (!window) {
        log("No focused window - ignoring keyboard shortcut AutoTileNCols");
        return;
    }
    reset_window(window);
    let mind = window.get_monitor();
    let work_area = getWorkAreaByMonitorIdx(mind);
    const monitors = activeMonitors();
    let monitor = monitors[mind];
    let workArea = getWorkAreaByMonitor(monitor);
    let windows = getNotFocusedWindowsOfMonitor(monitor);
    let nbWindowOnEachSide = Math.ceil((windows.length + 1) / cols);
    let winHeight = workArea.height / nbWindowOnEachSide;
    let countWin = 0;
    move_resize_window_with_margins(focusMetaWindow, workArea.x + countWin % cols * workArea.width / cols, workArea.y + (Math.floor(countWin / cols) * winHeight), workArea.width / cols, winHeight);
    countWin++;
    // todo make function
    for (let windowIdx in windows) {
        let metaWindow = windows[windowIdx].meta_window;
        reset_window(metaWindow);
        move_resize_window_with_margins(metaWindow, workArea.x + countWin % cols * workArea.width / cols, workArea.y + (Math.floor(countWin / cols) * winHeight), workArea.width / cols, winHeight);
        countWin++;
    }
    log("AutoTileNCols done");
}
function SnapToNeighborsBind() {
    log("SnapToNeighbors keybind invoked");
    let window = getFocusApp();
    if (!window) {
        log("No focused window - ignoring keyboard shortcut SnapToNeighbors");
        return;
    }
    snapToNeighbors(window);
}
function GridSettingsButton(text, cols, rows) {
    this._init(text, cols, rows);
}
GridSettingsButton.prototype = {
    _init: function (text, cols, rows) {
        this.cols = cols;
        this.rows = rows;
        this.text = text;
        this.actor = new St.Button({ style_class: 'settings-button',
            reactive: true,
            can_focus: true,
            track_hover: true });
        this.label = new St.Label({ style_class: 'settings-label', reactive: true, can_focus: true, track_hover: true, text: this.text });
        this.actor.add_actor(this.label);
        this.actor.connect('button-press-event', Lang.bind(this, this._onButtonPress));
    },
    _onButtonPress: function () {
        nbCols = this.cols;
        nbRows = this.rows;
        refreshGrids();
    }
};
function Grid(monitor_idx, screen, title, cols, rows) {
    this._init(monitor_idx, screen, title, cols, rows);
}
Grid.prototype = {
    _init: function (monitor_idx, monitor, title, cols, rows) {
        this.connectHideTiling = false;
        let workArea = getWorkArea(monitor, monitor_idx);
        this.tableWidth = 320;
        this.tableHeight = (this.tableWidth / workArea.width) * workArea.height;
        this.borderwidth = 2;
        this.actor = new St.BoxLayout({ vertical: true,
            style_class: 'grid-panel',
            reactive: true,
            can_focus: true,
            track_hover: true
        });
        this.actor.connect('enter-event', Lang.bind(this, this._onMouseEnter));
        this.actor.connect('leave-event', Lang.bind(this, this._onMouseLeave));
        this.animation_time = gridSettings[SETTINGS_ANIMATION] ? 0.3 : 0;
        this.topbar = new TopBar(title);
        this.bottombarContainer = new St.Bin({ style_class: 'bottom-box-container',
            reactive: true,
            can_focus: true,
            track_hover: true
        });
        this.bottombar = new St.Widget({
            style_class: 'bottom-box',
            can_focus: true,
            track_hover: true,
            reactive: true,
            width: this.tableWidth - 20,
            height: 36,
            layout_manager: new Clutter.GridLayout()
        });
        this.bottombar_table_layout = this.bottombar.layout_manager;
        this.bottombar_table_layout.set_row_homogeneous(true);
        this.bottombar_table_layout.set_column_homogeneous(true);
        this.bottombarContainer.add_actor(this.bottombar);
        this.veryBottomBarContainer = new St.Bin({ style_class: 'very-bottom-box-container',
            reactive: true,
            can_focus: true,
            track_hover: true
        });
        this.veryBottomBar = new St.Widget({
            style_class: 'very-bottom-box',
            can_focus: true,
            track_hover: true,
            reactive: true,
            width: this.tableWidth - 20,
            height: 36,
            layout_manager: new Clutter.GridLayout()
        });
        this.veryBottomBar_table_layout = this.veryBottomBar.layout_manager;
        this.bottombar_table_layout.set_row_homogeneous(true);
        this.veryBottomBar_table_layout.set_column_homogeneous(true);
        this.veryBottomBarContainer.add_actor(this.veryBottomBar);
        let rowNum = 0;
        let colNum = 0;
        let maxPerRow = 4;
        let gridSettingsButton = gridSettings[SETTINGS_GRID_SIZES];
        for (var index = 0; index < gridSettingsButton.length; index++) {
            if (colNum >= maxPerRow) {
                colNum = 0;
                rowNum += 2;
            }
            let button = gridSettingsButton[index];
            button = new GridSettingsButton(button.text, button.cols, button.rows);
            this.bottombar_table_layout.attach(button.actor, colNum, rowNum, 1, 1);
            button.actor.connect('notify::hover', Lang.bind(this, this._onSettingsButton));
            colNum++;
        }
        this.tableContainer = new St.Bin({ style_class: 'table-container',
            reactive: true,
            can_focus: true,
            track_hover: true
        });
        this.table = new St.Widget({
            style_class: 'table',
            can_focus: true,
            track_hover: true,
            reactive: true,
            height: this.tableHeight,
            width: this.tableWidth - 2,
            layout_manager: new Clutter.GridLayout()
        });
        this.table_table_layout = this.table.layout_manager;
        this.table_table_layout.set_row_homogeneous(true);
        this.table_table_layout.set_column_homogeneous(true);
        this.tableContainer.add_actor(this.table);
        this.actor.add_actor(this.topbar.actor);
        this.actor.add_actor(this.tableContainer);
        this.actor.add_actor(this.bottombarContainer);
        this.actor.add_actor(this.veryBottomBarContainer);
        this.monitor = monitor;
        this.monitor_idx = monitor_idx;
        this.rows = rows;
        this.title = title;
        this.cols = cols;
        this.isEntered = false;
        if (!toggleSettingListener) {
            toggleSettingListener = new ToggleSettingsButtonListener();
        }
        let toggle = new ToggleSettingsButton("animation", SETTINGS_ANIMATION);
        this.veryBottomBar_table_layout.attach(toggle.actor, 0, 0, 1, 1);
        toggleSettingListener.addActor(toggle);
        toggle = new ToggleSettingsButton("auto-close", SETTINGS_AUTO_CLOSE);
        this.veryBottomBar_table_layout.attach(toggle.actor, 1, 0, 1, 1);
        toggleSettingListener.addActor(toggle);
        let action = new AutoTileMainAndList(this);
        this.veryBottomBar_table_layout.attach(action.actor, 2, 0, 1, 1);
        action.connect('resize-done', Lang.bind(this, this._onResize));
        action = new AutoTileTwoList(this);
        this.veryBottomBar_table_layout.attach(action.actor, 3, 0, 1, 1);
        action.connect('resize-done', Lang.bind(this, this._onResize));
        this.x = 0;
        this.y = 0;
        this.interceptHide = false;
        this._displayElements();
        this.normalScaleY = this.actor.scale_y;
        this.normalScaleX = this.actor.scale_x;
    },
    _displayElements: function () {
        this.elements = new Array();
        let width = (this.tableWidth / this.cols); // - 2*this.borderwidth;
        let height = (this.tableHeight / this.rows); // - 2*this.borderwidth;
        this.elementsDelegate = new GridElementDelegate();
        this.elementsDelegate.connect('resize-done', Lang.bind(this, this._onResize));
        for (let r = 0; r < this.rows; r++) {
            for (let c = 0; c < this.cols; c++) {
                if (c == 0) {
                    this.elements[r] = new Array();
                }
                let element = new GridElement(this.monitor, width, height, c, r);
                this.elements[r][c] = element;
                element.actor._delegate = this.elementsDelegate;
                this.table_table_layout.attach(element.actor, c, r, 1, 1);
                element.show();
            }
        }
    },
    forceGridElementDelegate: function (x, y, w, h) {
        this.elementsDelegate.forceArea(this.elements[y][x], this.elements[h][w]);
    },
    refresh: function () {
        //this.elementsDelegate._logActiveActors("Grid refresh active actors");
        this.elementsDelegate._resetGrid();
        for (let r = 0; r < this.rows; r++) {
            for (let c = 0; c < this.cols; c++) {
                this.elements[r][c]._disconnect();
            }
        }
        this.table.destroy_all_children();
        this.cols = nbCols;
        this.rows = nbRows;
        this._displayElements();
    },
    set_position: function (x, y) {
        this.x = x;
        this.y = y;
        this.actor.set_position(x, y);
    },
    show: function () {
        this.interceptHide = true;
        this.elementsDelegate.reset();
        let time = (gridSettings[SETTINGS_ANIMATION]) ? 0.3 : 0;
        Main$1.uiGroup.set_child_above_sibling(this.actor, null);
        Main$1.layoutManager.removeChrome(this.actor);
        Main$1.layoutManager.addChrome(this.actor);
        //this.actor.y = 0 ;
        if (time > 0) {
            this.actor.scale_y = 0;
            this.actor.scale_x = 0;
            this.actor.ease({
                time: this.animation_time,
                opacity: 255,
                visible: true,
                transition: Clutter.AnimationMode.EASE_OUT_QUAD,
                scale_x: this.normalScaleX,
                scale_y: this.normalScaleY,
                onComplete: this._onShowComplete
            });
        }
        else {
            this.actor.scale_x = this.normalScaleX;
            this.actor.scale_y = this.normalScaleY;
            this.actor.opacity = 255;
            this.actor.visible = true;
        }
        this.interceptHide = false;
    },
    hide: function (immediate) {
        log("hide " + immediate);
        this.elementsDelegate.reset();
        let time = (gridSettings[SETTINGS_ANIMATION]) ? 0.3 : 0;
        if (!immediate && time > 0) {
            this.actor.ease({
                time: this.animation_time,
                opacity: 0,
                visible: false,
                scale_x: 0,
                scale_y: 0,
                transition: Clutter.AnimationMode.EASE_OUT_QUAD,
                onComplete: this._onHideComplete
            });
        }
        else {
            this.actor.opacity = 0;
            this.actor.visible = false;
            //this.actor.y = 0;
            this.actor.scale_x = 0;
            this.actor.scale_y = 0;
        }
    },
    _onHideComplete: function () {
    },
    _onShowComplete: function () {
    },
    _onResize: function (actor, event) {
        log("resize-done: " + actor);
        updateRegions();
        if (gridSettings[SETTINGS_AUTO_CLOSE]) {
            log("Emitting hide-tiling");
            this.emit('hide-tiling');
        }
    },
    _onMouseEnter: function () {
        if (!this.isEntered) {
            this.elementsDelegate.reset();
            this.isEntered = true;
        }
    },
    _onMouseLeave: function () {
        let [x, y, mask] = global.get_pointer();
        if (this.elementsDelegate && (x <= this.actor.x || x >= (this.actor.x + this.actor.width)) || (y <= this.actor.y || y >= (this.actor.y + this.actor.height))) {
            this.isEntered = false;
            this.elementsDelegate.reset();
            refreshGrids();
        }
    },
    _onSettingsButton: function () {
        this.elementsDelegate.reset();
    },
    _destroy: function () {
        log("Grid _destroy");
        for (let r in this.elements) {
            for (let c in this.elements[r]) {
                this.elements[r][c]._destroy();
            }
        }
        this.elementsDelegate._destroy();
        this.topbar._destroy();
        this.monitor = null;
        this.rows = null;
        this.title = null;
        this.cols = null;
        log("Disconnect hide-tiling");
        this.disconnect(this.connectHideTiling);
    }
};
Signals.addSignalMethods(Grid.prototype);
function GridElementDelegate() {
    this._init();
}
GridElementDelegate.prototype = {
    _init: function () {
        this.activated = false;
        this.first = false;
        this.currentElement = false;
        this.activatedActors = false;
    },
    _allSelected: function () {
        return (this.activatedActors.length == (nbCols * nbRows));
    },
    _onButtonPress: function (gridElement) {
        log("GridElementDelegate _onButtonPress " + gridElement.coordx + ":" + gridElement.coordy);
        //this._logActiveActors("GridElementDelegate _onButtonPress active actors");
        if (!this.currentElement) {
            this.currentElement = gridElement;
        }
        if (this.activated == false) {
            log("GridElementDelegate first activation");
            this.activated = true;
            gridElement.active = true;
            this.activatedActors = new Array();
            this.activatedActors.push(gridElement);
            this.first = gridElement;
        }
        else {
            log("GridElementDelegate resize");
            //Check this.activatedActors if equals to nbCols * nbRows
            //before doing anything with the window it must be unmaximized
            //if so move the window then maximize instead of change size
            //if not move the window and change size
            reset_window(focusMetaWindow);
            let areaWidth, areaHeight, areaX, areaY;
            [areaX, areaY, areaWidth, areaHeight] = this._computeAreaPositionSize(this.first, gridElement);
            if (this._allSelected() && gridSettings[SETTINGS_WINDOW_MARGIN_FULLSCREEN_ENABLED] === false) {
                move_maximize_window(focusMetaWindow, areaX, areaY);
            }
            else {
                move_resize_window_with_margins(focusMetaWindow, areaX, areaY, areaWidth, areaHeight);
            }
            //this._logActiveActors("GridElementDelegate _onButtonPress end active actors");
            this._resizeDone();
        }
    },
    _resizeDone: function () {
        log("resizeDone, emitting signal resize-done");
        this.emit('resize-done');
    },
    reset: function () {
        this._resetGrid();
        this.activated = false;
        this.first = false;
        this.currentElement = false;
    },
    _resetGrid: function () {
        this._hideArea();
        if (this.currentElement) {
            this.currentElement._deactivate();
        }
        for (var act in this.activatedActors) {
            this.activatedActors[act]._deactivate();
        }
        this.activatedActors = new Array();
    },
    _getVarFromGridElement: function (fromGridElement, toGridElement) {
        let minX = Math.min(fromGridElement.coordx, toGridElement.coordx);
        let maxX = Math.max(fromGridElement.coordx, toGridElement.coordx);
        let minY = Math.min(fromGridElement.coordy, toGridElement.coordy);
        let maxY = Math.max(fromGridElement.coordy, toGridElement.coordy);
        return [minX, maxX, minY, maxY];
    },
    refreshGrid: function (fromGridElement, toGridElement) {
        this._resetGrid();
        let [minX, maxX, minY, maxY] = this._getVarFromGridElement(fromGridElement, toGridElement);
        let key = getMonitorKey(fromGridElement.monitor);
        let grid = grids[key];
        for (let r = minY; r <= maxY; r++) {
            for (let c = minX; c <= maxX; c++) {
                let element = grid.elements[r][c];
                element._activate();
                this.activatedActors.push(element);
            }
        }
        this._displayArea(fromGridElement, toGridElement);
    },
    _computeAreaPositionSize: function (fromGridElement, toGridElement) {
        let [minX, maxX, minY, maxY] = this._getVarFromGridElement(fromGridElement, toGridElement);
        let monitor = fromGridElement.monitor;
        let workArea = getWorkAreaByMonitor(monitor);
        let areaWidth = (workArea.width / nbCols) * ((maxX - minX) + 1);
        let areaHeight = (workArea.height / nbRows) * ((maxY - minY) + 1);
        let areaX = workArea.x + (minX * (workArea.width / nbCols));
        let areaY = workArea.y + (minY * (workArea.height / nbRows));
        return [areaX, areaY, areaWidth, areaHeight];
    },
    forceArea: function (fromGridElement, toGridElement) {
        let areaWidth, areaHeight, areaX, areaY;
        [areaX, areaY, areaWidth, areaHeight] = this._computeAreaPositionSize(fromGridElement, toGridElement);
        area.width = areaWidth;
        area.height = areaHeight;
        area.x = areaX;
        area.y = areaY;
    },
    _displayArea: function (fromGridElement, toGridElement) {
        let areaWidth, areaHeight, areaX, areaY;
        [areaX, areaY, areaWidth, areaHeight] = this._computeAreaPositionSize(fromGridElement, toGridElement);
        area.add_style_pseudo_class('activate');
        if (gridSettings[SETTINGS_ANIMATION]) {
            area.ease({
                time: 0.2,
                x: areaX,
                y: areaY,
                width: areaWidth,
                height: areaHeight,
                transition: Clutter.AnimationMode.EASE_OUT_QUAD
            });
        }
        else {
            area.width = areaWidth;
            area.height = areaHeight;
            area.x = areaX;
            area.y = areaY;
        }
    },
    _hideArea: function () {
        area.remove_style_pseudo_class('activate');
    },
    _onHoverChanged: function (gridElement) {
        log("GridElementDelegate _onHoverChange " + gridElement.coordx + ":" + gridElement.coordy);
        if (this.activated) {
            this.refreshGrid(this.first, gridElement);
            this.currentElement = gridElement;
        }
        else if (!this.currentElement || gridElement.id != this.currentElement.id) {
            if (this.currentElement) {
                this.currentElement._deactivate();
            }
            this.currentElement = gridElement;
            this.currentElement._activate();
            this._displayArea(gridElement, gridElement);
        }
    },
    _destroy: function () {
        this.activated = null;
        this.first = null;
        this.currentElement = null;
        this.activatedActors = null;
    }
};
Signals.addSignalMethods(GridElementDelegate.prototype);
function GridElement(monitor, width, height, coordx, coordy) {
    this._init(monitor, width, height, coordx, coordy);
}
GridElement.prototype = {
    _init: function (monitor, width, height, coordx, coordy) {
        this.actor = new St.Button({ style_class: 'table-element', reactive: true, can_focus: true, track_hover: true });
        this.actor.visible = false;
        this.actor.opacity = 0;
        this.monitor = monitor;
        this.coordx = coordx;
        this.coordy = coordy;
        this.width = width;
        this.height = height;
        this.id = getMonitorKey(monitor) + "-" + coordx + ":" + coordy;
        this.actor.connect('button-press-event', Lang.bind(this, this._onButtonPress));
        this.hoverConnect = this.actor.connect('notify::hover', Lang.bind(this, this._onHoverChanged));
        this.active = false;
    },
    show: function () {
        this.actor.opacity = 255;
        this.actor.visible = true;
    },
    hide: function () {
        this.actor.opacity = 0;
        this.actor.visible = false;
    },
    _onButtonPress: function () {
        this.actor._delegate._onButtonPress(this);
    },
    _onHoverChanged: function () {
        this.actor._delegate._onHoverChanged(this);
    },
    _activate: function () {
        if (!this.active) {
            this.actor.add_style_pseudo_class('activate');
            this.active = true;
        }
    },
    _deactivate: function () {
        if (this.active) {
            this.actor.remove_style_pseudo_class('activate');
            this.active = false;
        }
    },
    _clean: function () {
        Main$1.uiGroup.remove_actor(area);
    },
    _disconnect: function () {
        this.actor.disconnect(this.hoverConnect);
    },
    _destroy: function () {
        this.monitor = null;
        this.coordx = null;
        this.coordy = null;
        this.width = null;
        this.height = null;
        this.active = null;
    }
};

registerExtension(function () { }, enable, disable);
