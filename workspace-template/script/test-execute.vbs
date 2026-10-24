' Run this file from the NppMenuScripts menu item "Run Command with Output Pane"
' or "Run Command in Console". The command passes the file path and name as
' arguments, and supplies the current filename, line, and selection through environment variables.

Option Explicit

Dim shell, processEnv, i
Set shell = CreateObject("WScript.Shell")
Set processEnv = shell.Environment("PROCESS")

WScript.Echo "cscript command execution example"
WScript.Echo "Command-line arguments: " & WScript.Arguments.Count
For i = 0 To WScript.Arguments.Count - 1
  WScript.Echo "Argument " & i & ": [" & WScript.Arguments(i) & "]"
Next
WScript.Echo "File name: [" & processEnv("NMS_FILE_NAME") & "]"
WScript.Echo "Current line (trailing spaces are preserved):"
WScript.Echo "[" & processEnv("NMS_LINE_TEXT") & "]"
WScript.Echo "Selected text (line breaks are preserved):"
WScript.Echo "["
WScript.Echo processEnv("NMS_SELECT_TEXT")
WScript.Echo "]"
