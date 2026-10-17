# NppMenuScripts

[English](README.md) | **繁體中文**

NppMenuScripts 是 Notepad++ 的 x64 外掛程式。它可讓您自訂「選單」或「工具列」，並執行自己撰寫的腳本。支援 JavaScript、Python 和 Perl。



## 功能概述
- 透過 `menu.json` 檔，配置「選單」或「工具列」。
- 與編輯中的文件互動：
  - 內建 Helper API 模組：
    - JavaScript - `menu-helper.js`
    - Python - `menu_helper.py`
    - Perl - `MenuHelper.pm`
  - 透過 Helper API 開啟檔案並切換至該文件，或保留目前文件；也可讀取或修改「全文」、「所在列」和「選取文字」，以及取得「檔案路徑」和「游標位置」。
  - 提供原生 `npp.alert()`、`npp.prompt()`、`npp.confirm()` 對話框。
- 即使未使用 Helper API，`stdout` 和 `stderr` 也會直接顯示在「輸出面板」。
- 按住 Ctrl 並點擊自訂「選單」項目或「工具列」按鈕，可直接開啟對應腳本進行編輯；檔案不存在時可選擇建立範本。
- 關閉 Notepad++ 時會清理正在執行的腳本程序。
- 多國語言檔 `i18n.json`

## 系統需求

- Windows x64
- Notepad++ x64
- 若使用 JavaScript 需安裝 [Node.js® for Windows](https://nodejs.org/en/download/)
- 若使用 Python 需安裝 [Python for Windows](https://www.python.org/downloads/windows/)
- 若使用 Perl 需安裝 [Strawberry Perl for Windows](https://strawberryperl.com/)

## 安裝

1. 編譯或取得 `NppMenuScripts.dll`。
2. 建立 Plugin 目錄：`Notepad++\plugins\NppMenuScripts\`。
3. 將 `NppMenuScripts.dll` 放入該目錄。
4. 預設情況下，將 `menu.json`、`i18n.json`、`menu-helper.js`、`menu_helper.py`、`MenuHelper.pm`、`package.json` 與 `icon` 目錄放在 `NppMenuScripts.dll` 同一目錄。
5. 將 `.js`、`.mjs`、`.pl` 或 `.py` 腳本放在 `script_folder` 指定的目錄。
6. 重新啟動 Notepad++。

典型的目錄結構如下：

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


## 設定

`menu.json` 用來設定腳本目錄、選單階層以及鍵盤快捷鍵。您可以直接從 Notepad++ 主選單 **Plugins > NppMenuScripts > Open menu.json** 開啟它。它長得像這樣：

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

- `menu.json` 必須使用 UTF-8 編碼，預設會從 `NppMenuScripts.dll` 所在目錄載入。若要使用其他位置，可透過 **Plugins > NppMenuScripts > Set menu.json Path...** 設定，便不必直接修改需要系統管理員權限的 `Program Files` 目錄。
- `script_folder`：腳本目錄。可使用絕對路徑，或以 `menu.json` 所在目錄為基準的相對路徑，例如 `./script`、`../scripts`。
- 若更動了 `script_folder`，請將 `menu-helper.js` 和 `package.json` 拷到該目錄的上一層，讓 Node.js 能找到 Package Import Alias。
- `icon_folder`：工具列圖示目錄；相對路徑以 `menu.json` 所在目錄為基準。
- `toolbar`：以陣列設定工具列按鈕，每個項目指定 `icon`、`title` 和 `script`，最多 32 個。`title` 會作為按鈕的工具提示文字。範例圖示位於 `icon/sample.ico`。工具列設定變更後，請重新啟動 Notepad++。
- `menu`：每個選單分類都是物件陣列。腳本項目使用 `title` 和 `script`；子選單使用 `title` 和 `sub`，而 `sub` 內可再放子選單、腳本項目或空物件分隔線。可依此建立多層選單。將 `script` 設為 `{CURRENT_FILE}`，即可執行目前編輯中的 `.js`、`.mjs`、`.pl` 或 `.py` 檔案；工具列按鈕也支援此設定。檔案必須先儲存；若有未儲存的修改，NppMenuScripts 會先詢問是否儲存。
- 若要設定快捷鍵，可在 `title` 後加上 Tab 字元 `\t` 和快捷鍵。
- 修改並儲存 `menu.json` 後，選擇 **Plugins > NppMenuScripts > Rebuild Menu & Toolbar** 即可重建腳本選單。


### 鍵盤快捷鍵

每個「選單項目名稱」後面，可以使用 **Tab 字元 `\t`** 加上快捷按鍵：

```json
{ "title": "My Script\tCtrl+Shift+R", "script": "my-script.js" }
```

支援的修飾鍵：

| 修飾鍵 | 寫法 |
|---|---|
| Ctrl | `Ctrl` 或 `Control` |
| Shift | `Shift` |
| Alt | `Alt` |

支援的按鍵：

| 按鍵 | 寫法 |
|---|---|
| 英文字母／數字 | `A`–`Z`、`0`–`9` |
| 功能鍵 | `F1`–`F24` |
| Tab | `Tab` |

快捷鍵必須至少包含一個修飾鍵，例如 `Ctrl+1`、`Alt+F8` 或 `Shift+Tab`；單獨的 `Tab` 不會註冊。快捷鍵透過 Windows `RegisterHotKey` 註冊，如果組合已被 Windows 或其他程式占用，就可能無法使用。


### 多國語言

`i18n.json` 為本程式的語言檔，依 Notepad++ 目前語系顯示。您可自行在此添加您的語言，重啟 Notepad++ 後才會發生作用。語言代碼請參考 [Notepad++ User Manual](https://npp-user-manual.org/docs/command-prompt/#langCodeList) 點擊 "show Language Codes" 展開。



## 腳本語言

您的腳本檔案請以 **UTF-8** 編碼儲存，尤其是含有中文等非 ASCII 字元時。

初次安裝此外掛後，可從 **Plugins > NppMenuScripts > Open Scripts Folder** 開啟內附的腳本範例，或按住 Ctrl 並點擊腳本選單項目，直接開啟範例原始碼。

### JavaScript Helper API



#### CommonJS 與 ES Module

```js
/* CommonJS (.js) */
const npp = require('#menu-helper');
```
或：
```js
/* ES Module (.mjs) */
import npp from '#menu-helper';
```

### Promise 非同步 API
非同步 (Async) 工作，請使用 Promise API。各 Method 回傳值會以 Promise 包裝。範例請參考 `script/test-async-alert.js`。

```js
/* CommonJS (.js) */
const npp = require('#menu-helper').promises;
```
或：
```js
/* ES Module (.mjs) */
import nppModule from '#menu-helper';
const npp = nppModule.promises;
```


**注意事項：**
- 在同一支 JavaScript 中不可同時混用「同步」與「非同步」。
- 若您曾變更 `script_folder` 的預設路徑，JavaScript Helper 和 `package.json` 可能也需要複製到其上一層目錄。Python 和 Perl Helper 則從外掛目錄載入。
- 若您曾複製或移動 Helper API 模組，當模組與新版 `NppMenuScripts.dll` 不相容時，首次呼叫 Helper API 會提示您更新該模組。


### Python Helper API

Python 腳本匯入 Helper API，並使用 `npp` 作為別名：

```python
import menu_helper as npp

npp.alert("Hello from Python")
```

NppMenuScripts 會將外掛目錄加入 Python 模組搜尋路徑，讓 Python 可以載入 `menu_helper.py`。

### Perl Helper API

Perl 腳本載入 `MenuHelper.pm`，建立物件後使用 Helper API：

```perl
use MenuHelper ();
my $npp = MenuHelper->new();

$npp->alert('Hello from Perl');
```

NppMenuScripts 會將外掛目錄加入 Perl 模組搜尋路徑，讓 Perl 可以載入 `MenuHelper.pm`。

### API 列表

| API | 回傳值 | 功能 |
|---|---|---|
| `alert(message, [title])` | `void` | 訊息對話框 |
| `prompt(message, [defaultValue], [title])` | `string / null` | 提示使用者輸入文字；按取消時回傳 `null` |
| `confirm(message, [title])` | `true / false` | 確認對話框 |
| `getLine()`<br>`setLine(text)` | `string / boolean` | 讀取或置換游標所在**列文字** |
| `getSelection()`<br>`setSelection(text)`<br>`hasSelection()` | `string / boolean / boolean` | 讀取或置換目前**選取文字**；若沒有選取，則在游標處插入文字 |
| `getText()`<br>`setText(text)` | `string / boolean` | 讀取或置換當前文件**全部文字** |
| `getClipBoard()`<br>`setClipBoard(text)` | `string / boolean` | 讀取或設定**剪貼簿**文字 |
| `getFileName()` | `string` | 取得目前文件完整路徑 |
| `saveFile()` | `boolean` | 儲存目前文件 |
| `getOpenFiles()` | `string[]` | 回傳所有已開啟且有檔名的文件完整路徑 |
| `closeFile(fullPathFileName)` | `boolean` | 關閉指定檔案；若使用者取消未儲存提示則回傳 `false` |
| `openFile(fullPathFileName)` | `boolean` | 開啟檔案並切換至該文件 |
| `openFileInBackground(fullPathFileName)` | `boolean` | 另開檔案，目前文件不變 |
| `getCursor()`<br>`setCursor(line, column)` | `{line: number, column: number} / boolean` | 取得或設定目前游標位置 (0 起算) |
| `getScrollLine()`<br>`setScrollLine(line)` | `number / boolean` | 取得或設定編輯區捲動行號 (0 起算)；若在摺疊中會自動展開，若該行隱藏則回傳 `false` |
| `setStatusBarText(text)` | `boolean` | 設定 Notepad++ 狀態列文字 |
| `setOutputPaneTitle(text)` | `boolean` | 設定 Output Pane 標題 |
| `runMenuCommand(commandID)` | `boolean` | 依照 [taiwaneseMandarin.xml](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/installer/nativeLang/taiwaneseMandarin.xml) 中的 ID 執行 Notepad++ 選單指令 |

註：
- 布林值在 Python 回傳 True/False；在 Perl 回傳 1/0。
- 各腳本語言的 Helper API 為同步呼叫 (Synchronous)。僅 JavaScript 另外提供非同步呼叫 (Asynchronous)。
- API 參數或 menu.json 中的檔案路徑分隔符 `\` 及 `/`，兩者皆可使用。若使用 `\` 記得跳脫，像這樣 `\\`。

## 編譯 NppMenuScripts.dll

`build-x64.bat` 使用 MinGW / Strawberry GCC。

1. 執行 `get-cjson.bat` 取得所需的 cJSON 原始碼。
2. 確認 `g++` 已在環境變數 `PATH` 中可執行。
3. 執行 `build-x64.bat`。
4. 產出 DLL 於 `build/NppMenuScripts.dll`。

## License

NppMenuScripts 採用 **MIT License** 授權。詳細內容請參閱 [LICENSE](LICENSE)。
