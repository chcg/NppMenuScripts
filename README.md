# NppMenuScripts

NppMenuScripts is an x64 Notepad++ plugin. It lets you customize menus and toolbars, and run your own scripts. It supports JavaScript, Python, and Perl.

## Features

- Configure menus and toolbars through `menu.json`.
- Interact with the active document:
  - Built-in Helper API modules:
    - JavaScript - `menu-helper.js`
    - Python - `menu_helper.py`
    - Perl - `MenuHelper.pm`
  - Use the Helper API to open files with or without switching to them, read or modify the full text, current line, and selected text, and retrieve the file path and cursor position.
  - Provides native `npp.alert()`, `npp.prompt()`, and `npp.confirm()` dialogs.
- Even without using the Helper API, `stdout` and `stderr` are displayed directly in the Output Pane.
- Hold Ctrl and click a custom menu item or toolbar button to open its script for editing. If the file does not exist, you can choose to create a template.
- Running script processes are cleaned up when Notepad++ shuts down.
- The language file is `i18n.json`.

## Requirements

- Windows x64
- Notepad++ x64
- For JavaScript, install [Node.js for Windows](https://nodejs.org/en/download/).
- For Python, install [Python for Windows](https://www.python.org/downloads/windows/).
- For Perl, install [Strawberry Perl for Windows](https://strawberryperl.com/).

## Installation

1. Build or obtain `NppMenuScripts.dll`.
2. Create the plugin directory:
   `Notepad++\plugins\NppMenuScripts\`
3. Copy `NppMenuScripts.dll` into that directory.
4. Place `menu.json`, `i18n.json`, `menu-helper.js`, `menu_helper.py`, `MenuHelper.pm`, `package.json`, and the `icon` directory in the same directory as `NppMenuScripts.dll` for the default setup.
5. Put your `.js`, `.mjs`, `.pl`, or `.py` scripts in the directory specified by `script_folder`.
6. Restart Notepad++.

A typical layout is:

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

## Configure `menu.json`

`menu.json` configures the script directory, menu hierarchy, and keyboard shortcuts. You can open it from **Plugins > NppMenuScripts > Open menu.json** in the Notepad++ main menu. For example:

```json
{
  "script_folder": "./script",
  "menu": {
    "Tools": [
      { "title": "Hello World\tCtrl+1", "script": "hello-world.js" },
      {},
      { "title": "Run Report\tCtrl+Shift+R", "script": "report.js" },
      { "title": "Open Utility\tAlt+F8", "script": "utility.js" },
      {},
      {
        "title": "Language Tests",
        "sub": [
          {
            "title": "Perl Tests",
            "sub": [
              { "title": "Hello World", "script": "hello-world.pl" }
            ]
          }
        ]
      },
      { "title": "Run Current Script", "script": "{CURRENT_FILE}" }
    ],
    "Document Tools": [
      { "title": "Format Document", "script": "format.js" },
      { "title": "Check Document", "script": "check.js" }
    ]
  },
  "icon_folder": "./icon",
  "toolbar": [
    {
      "icon": "sample.ico",
      "script": "hello-world.js",
      "title": "Run sample"
    },
    {
      "icon": "sample.ico",
      "script": "{CURRENT_FILE}",
      "title": "Run Current Script"
    }
  ]
}
```

- `menu.json` must use UTF-8 encoding. By default, it is loaded from the directory containing `NppMenuScripts.dll`. To use a different location, choose **Plugins > NppMenuScripts > Set menu.json Path...**; this avoids editing files in the `Program Files` directory, which requires administrator permission.
- `script_folder`: The script directory. Use an absolute path or a relative path based on the directory containing `menu.json`, such as `./script` or `../scripts`.
- If you change `script_folder`, copy `menu-helper.js` and `package.json` to the directory above it so Node.js can resolve the package import alias.
- `icon_folder`: The toolbar icon directory. Relative paths are based on the directory containing `menu.json`.
- `toolbar`: An array of toolbar button objects with `icon`, `title`, and `script` properties, up to 32 buttons. The `title` is shown as the button tooltip. The example icon is `icon/sample.ico`. Restart Notepad++ after changing the toolbar configuration.
- `menu`: Each category is an array of menu items. Script items use `title` and `script`; submenus use `title` and `sub`, whose array can contain more submenus, script items, or empty objects for separators. This supports multiple menu levels. Set `script` to `{CURRENT_FILE}` to run the active `.js`, `.mjs`, `.pl`, or `.py` file; this also works for toolbar buttons. The file must be saved, and NppMenuScripts asks to save it first if it has unsaved changes.
- Add a tab character `\t` and shortcut after a title to assign a keyboard shortcut.
- After editing and saving `menu.json`, choose **Plugins > NppMenuScripts > Rebuild Menu & Toolbar** to rebuild the script menu.

### Keyboard shortcuts

Add a shortcut to a menu item by inserting a **tab character `\t`** after its title:

```json
{ "title": "My Script\tCtrl+Shift+R", "script": "my-script.js" }
```

Supported modifier keys:

| Modifier | Syntax |
|---|---|
| Control | `Ctrl` or `Control` |
| Shift | `Shift` |
| Alt | `Alt` |

Supported keys:

| Key | Syntax |
|---|---|
| Letter or digit | `A`–`Z` or `0`–`9` |
| Function keys | `F1`–`F24` |
| Tab | `Tab` |

Every shortcut must include at least one modifier key. Examples include `Ctrl+1`, `Alt+F8`, and `Shift+Tab`. A shortcut consisting only of `Tab` is not registered. Windows registers shortcuts through `RegisterHotKey`, so a combination already in use by Windows or another application may not be available.

### Multilingual support

`i18n.json` is the language file for this plugin. NppMenuScripts selects translations based on the current Notepad++ interface language. You can add your own language to this file; restart Notepad++ for the changes to take effect. For language codes, see the [Notepad++ User Manual](https://npp-user-manual.org/docs/command-prompt/#langCodeList) and click **show Language Codes** to expand the list.

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

For asynchronous work, use the Promise API. Each method's return value is wrapped in a Promise. See `script/test-async-alert.js` for an example.

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

- Do not use the synchronous and asynchronous APIs together in the same script.
- If you changed the default `script_folder`, the JavaScript helper and `package.json` may also need to be copied to the directory above it. The Python and Perl helpers are loaded from the plugin directory.
- If you copied or moved a Helper API module, an incompatibility with a newer `NppMenuScripts.dll` is reported the first time a script calls the Helper API, prompting you to update the module.

### Python Helper API

Python scripts can import the Helper API using `npp` as an alias:

```python
import menu_helper as npp

npp.alert("Hello from Python")
```

NppMenuScripts adds the plugin directory to Python's module search path so Python can import `menu_helper.py`.

### Perl Helper API

Perl scripts can load `MenuHelper.pm`, create an object, and use the Helper API:

```perl
use MenuHelper ();
my $npp = MenuHelper->new();

$npp->alert('Hello from Perl');
```

NppMenuScripts adds the plugin directory to Perl's module search path so Perl can load `MenuHelper.pm`.

### API reference

| API | Returns | Description |
|---|---|---|
| `alert(message, [title])` | `void` | Shows a message dialog. |
| `prompt(message, [defaultValue], [title])` | `string / null` | Prompts the user for text. Returns `null` when cancelled. |
| `confirm(message, [title])` | `true / false` | Shows a confirmation dialog. |
| `getLine()`<br>`setLine(text)` | `string / boolean` | Gets or replaces the current **line text**. |
| `getSelection()`<br>`setSelection(text)`<br>`hasSelection()` | `string / boolean / boolean` | Gets or replaces the **selected text**. If no text is selected, `setSelection()` inserts text at the cursor. |
| `getText()`<br>`setText(text)` | `string / boolean` | Gets or replaces **all text** in the current document. |
| `getClipBoard()`<br>`setClipBoard(text)` | `string / boolean` | Gets or sets **clipboard text**. |
| `getFileName()` | `string` | Returns the full path of the current document. |
| `saveFile()` | `boolean` | Saves the current document. |
| `getOpenFiles()` | `string[]` | Returns the full paths of all open, named documents. |
| `closeFile(fullPathFileName)` | `boolean` | Closes the specified open file. If the user cancels the save prompt, returns `false`. |
| `openFile(fullPathFileName)` | `boolean` | Opens a file and switches to it. |
| `openFileInBackground(fullPathFileName)` | `boolean` | Opens a file without changing the current document. |
| `getCursor()`<br>`setCursor(line, column)` | `{line: number, column: number} / boolean` | Gets or sets the cursor position (0-based). |
| `getScrollLine()`<br>`setScrollLine(line)` | `number / boolean` | Gets or sets the editor scroll line (0-based). A folded line is expanded automatically; returns `false` if the line is hidden. |
| `setStatusBarText(text)` | `boolean` | Sets the text of the Notepad++ status bar. |
| `setOutputPaneTitle(text)` | `boolean` | Sets the Output Pane title. |
| `runMenuCommand(commandID)` | `boolean` | Runs a Notepad++ menu command by its ID from [`english.xml`](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/installer/nativeLang/english.xml). |

Note:
- Boolean values are returned as `True`/`False` in Python and `1`/`0` in Perl.
- The Helper API is synchronous in all supported languages. Only JavaScript also provides asynchronous calls.
- File paths in API arguments and `menu.json` can use either `\` or `/` as the separator. When writing a path in a string in `menu.json` or a script, escape backslashes as `\\`.

## Building NppMenuScripts.dll

`build-x64.bat` uses MinGW / Strawberry GCC.

1. Run `get-cjson.bat` to download the required cJSON source files.
2. Make sure `g++` is available on your `PATH`.
3. Run `build-x64.bat`.
4. The DLL is created at `build/NppMenuScripts.dll`.


## License

NppMenuScripts is released under the **MIT License**. See [LICENSE](LICENSE).
