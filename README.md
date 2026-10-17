# NppMenuScripts

**English** | [中文](README.zh-TW.md)

NppMenuScripts is an x64 Notepad++ plugin. It lets you customize menus and toolbars, and run your own scripts. It supports JavaScript, Python, and Perl.

## Features

- Configure menus and toolbars through `menu.json`.
- Interact with the active document:
  - Built-in Helper API modules:
    - JavaScript - `menu-helper.js`
    - Python - `menu_helper.py`
    - Perl - `MenuHelper.pm`
  - Use the Helper API to open files and switch to them or keep the current document active; read or modify the full text, current line, and selected text; and retrieve the file path and cursor position.
  - Provides native `npp.alert()`, `npp.prompt()`, and `npp.confirm()` dialogs.
- Even without using the Helper API, `stdout` and `stderr` are displayed directly in the Output Pane. Basic ANSI color codes are supported.
- Hold Ctrl and click a custom menu item or toolbar button to open its script for editing. If the file does not exist, you can choose to create a template.
- Running script processes are cleaned up when Notepad++ shuts down.
- The multilingual language file is `i18n.json`.

## Requirements

- Windows x64
- Notepad++ x64
- For JavaScript, install [Node.js® for Windows](https://nodejs.org/en/download/).
- For Python, install [Python for Windows](https://www.python.org/downloads/windows/).
- For Perl, install [Strawberry Perl for Windows](https://strawberryperl.com/).

## Installation

1. Build or obtain `NppMenuScripts.dll`.
2. Create a `NppMenuScripts` folder under `Notepad++\plugins`, usually `C:\Program Files\Notepad++\plugins`.
3. By default, place the following files in that folder:
   `NppMenuScripts.dll`, `menu.json`, `i18n.json`, `menu-helper.js`, `menu_helper.py`, `MenuHelper.pm`, `package.json`, and the `icon` folder.
4. Put your `.js`, `.mjs`, `.pl`, or `.py` scripts in the folder specified by `script_folder`.
5. Restart Notepad++.

A typical folder structure is:

```text
Notepad++\
├─ plugins\
│  └─ NppMenuScripts\
│     ├─ NppMenuScripts.dll
│     ├─ menu.json
│     ├─ i18n.json
│     ├─ menu-helper.js
│     ├─ menu_helper.py
│     ├─ MenuHelper.pm
│     ├─ package.json
│     ├─ icon\
│     │  └─ run-sample.ico
│     └─ script\
│        ├─ hello-world.js
│        ├─ hello-world.py
│        └─ my-script.js
```

## Configuration

`menu.json` configures the script folder, menu hierarchy, and keyboard shortcuts. You can open it from the plugin menu using **Open menu.json**. For example:

```json
{
  "script_folder": "./script",
  "menu": {
    "Tools": [
      { "title": "Hello World\tCtrl+1", "script": "hello-world.js" },
      { "title": "Run Current Script", "script": "{CURRENT_FILE}" },
      {
        "title": "Python Tests", "sub": [
          { "title": "Hello World", "script": "hello-world.py" }
        ]
      }
    ],
    "Document Tools": [
      { "title": "Format Document", "script": "format.pl" }
    ]
  },
  "icon_folder": "./icon",
  "toolbar": [
    { "icon": "sample.ico", "title": "Run sample", "script": "hello-world.js" },
    { "icon": "sample.ico", "title": "Run Current Script", "script": "{CURRENT_FILE}" }
  ]
}
```

- `menu.json` must use UTF-8 encoding. By default, it is loaded from the folder containing `NppMenuScripts.dll`. To use a different location, choose **Plugins > NppMenuScripts > Set menu.json Path...**; this avoids editing files under `Program Files`.
- `script_folder`: The script folder. Use an absolute path or a relative path based on the folder containing `menu.json`, such as `./script` or `../scripts`.  
If you change `script_folder`, copy `menu-helper.js` and `package.json` to its parent folder so Node.js can resolve the package import alias.
- `icon_folder`: The toolbar icon folder. Relative paths are based on the folder containing `menu.json`.
- `toolbar`: Toolbar button settings. Up to 32 buttons are supported.
- `menu`: Menu settings. Nested submenus can be up to 16 levels deep.
- Use an empty object `{}` for a menu separator.
- Object properties:
  - `title`: The menu item label or toolbar button tooltip. To assign a shortcut, append a **tab character** `\t` followed by the shortcut name.
  - `script`: The script file name. Set it to `"{CURRENT_FILE}"` to run the currently edited script. Toolbar buttons support this setting too.
  - `icon`: The toolbar button icon file in `.ico` format. The icon must be 32×32 pixels with 32-bit color depth (full color with transparency).
  - `sub`: An array of submenu items, which can contain nested submenus or script items.
- After editing and saving `menu.json`, choose **Plugins > NppMenuScripts > Rebuild Menu & Toolbar** to review the changes. Notepad++ does not need to be restarted.

### Keyboard shortcuts

Add a shortcut after a menu item title by inserting a **tab character `\t`**:

```json
{ "title": "My Script\tCtrl+Shift+R", "script": "my-script.js" }
```

Supported modifier keys:

| Modifier | Syntax |
|---|---|
| Ctrl | `Ctrl` or `Control` |
| Shift | `Shift` |
| Alt | `Alt` |

Supported keys:

| Key | Syntax |
|---|---|
| Letters and digits | `A`–`Z`, `0`–`9` |
| Function keys | `F1`–`F24` |
| Tab | `Tab` |

Every shortcut must include at least one modifier key, such as `Ctrl+1`, `Alt+F8`, or `Shift+Tab`. A standalone `Tab` is not registered. Shortcuts are registered through Windows `RegisterHotKey`; a combination already used by Windows or another application may not be available.

### Multilingual support

`i18n.json` is the language file for this plugin. NppMenuScripts selects the language based on the current Notepad++ interface language. You can add your own language to this file; restart Notepad++ for the change to take effect. For language codes, see the [Notepad++ User Manual](https://npp-user-manual.org/docs/command-prompt/#langCodeList) and expand **show Language Codes**.

## Script languages

Save your script files as **UTF-8**, especially when they contain non-ASCII characters.

After installing the plugin, choose **Plugins > NppMenuScripts > Open Scripts Folder** to open the included script examples. You can also hold Ctrl and click a script menu item to open its source in Notepad++.

### JavaScript Helper API

#### CommonJS and ES Modules

```js
/* CommonJS (.js) */
const npp = require('#menu-helper');
```

Or:

```js
/* ES Module (.mjs) */
import npp from '#menu-helper';
```

### Promise-based asynchronous API

For asynchronous work, use the Promise API. Each method returns a Promise. See `script/test-async-alert.js` for an example.

```js
/* CommonJS (.js) */
const npp = require('#menu-helper').promises;
```

Or:

```js
/* ES Module (.mjs) */
import nppModule from '#menu-helper';
const npp = nppModule.promises;
```

**Notes:**

- Do not mix the synchronous and asynchronous APIs in the same script.
- If you copied or moved a Helper API module, NppMenuScripts will notify you the first time the script calls the Helper API if the module is incompatible with the loaded `NppMenuScripts.dll`. Update the module to continue.

### Python Helper API

Python scripts can import the Helper API using `npp` as an alias:

```python
import menu_helper as npp

npp.alert("Hello from Python")
```

NppMenuScripts adds the plugin folder to Python's module search path so Python can import `menu_helper.py`.

### Perl Helper API

Perl scripts can load `MenuHelper.pm`, create an object, and use the Helper API:

```perl
use MenuHelper ();
my $npp = MenuHelper->new();

$npp->alert('Hello from Perl');
```

NppMenuScripts adds the plugin folder to Perl's module search path so Perl can load `MenuHelper.pm`.

### API reference

#### Dialogs

| API | Returns | Description |
|---|---|---|
| `alert(message, [title])` | `void` | Shows a message dialog. |
| `prompt(message, [defaultValue], [title])` | `string / null` | Prompts the user for text. Returns `null` when cancelled. |
| `confirm(message, [title])` | `true / false` | Shows a confirmation dialog. |

#### Current document text

| API | Returns | Description |
|---|---|---|
| `getLine()`<br>`setLine(text)` | `string / boolean` | Gets or replaces the text on the current **line**. |
| `getSelection()`<br>`setSelection(text)`<br>`hasSelection()` | `string / boolean / boolean` | Gets or replaces the **selected text**. If there is no selection, `setSelection()` inserts text at the cursor. |
| `getText()`<br>`setText(text)` | `string / boolean` | Gets or replaces **all text** in the current document. |
| `getClipBoard()`<br>`setClipBoard(text)` | `string / boolean` | Gets or sets **clipboard text**. |

#### Cursor and scrolling

| API | Returns | Description |
|---|---|---|
| `getCursor()`<br>`setCursor(line, column)` | `{line: number, column: number} / boolean` | Gets or sets the cursor position (0-based). |
| `getScrollLine()`<br>`setScrollLine(line)` | `number / boolean` | Gets or sets the editor scroll line (0-based). A folded section is expanded automatically; returns `false` if the line is hidden. |

#### Files

| API | Returns | Description |
|---|---|---|
| `getFileName()` | `string` | Returns the full path of the current document. |
| `getOpenFiles()` | `string[]` | Returns the full paths of all open, named documents. |
| `openFile(fullPathFileName)` | `boolean` | Opens a file and switches to it. |
| `openFileInBackground(fullPathFileName)` | `boolean` | Opens a file and keeps the current document active. |
| `saveFile()` | `boolean` | Saves the current document. Returns `true` on success and `false` if the document is unnamed or saving fails. |
| `closeFile(fullPathFileName)` | `boolean` | Closes the specified file. Returns `false` if the user cancels the unsaved-changes prompt. |

#### Other

| API | Returns | Description |
|---|---|---|
| `setStatusBarText(text)` | `boolean` | Sets the Notepad++ status bar text. |
| `setOutputPaneTitle(text)` | `boolean` | Sets the Output Pane title. |
| `runMenuCommand(commandID)` | `boolean` | Runs a Notepad++ menu command using its ID from [`english.xml`](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/installer/nativeLang/english.xml). |

**Notes:**

- Boolean values are returned as `True`/`False` in Python and `1`/`0` in Perl.
- The Helper API is synchronous in all supported languages. JavaScript also provides asynchronous calls.
- File paths accept either `\` or `/` as separators. Escape backslashes as `\\` when writing them in strings.

## Building NppMenuScripts.dll

`build-x64.bat` uses MinGW / Strawberry GCC.

1. Run `get-cjson.bat` to download the required cJSON source files.
2. Make sure `g++` is available on your `PATH`.
3. Run `build-x64.bat`.
4. The DLL is created at `build/NppMenuScripts.dll`.

## License

NppMenuScripts is released under the **MIT License**. See [LICENSE](LICENSE).