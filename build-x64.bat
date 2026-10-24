@echo off
setlocal

rem Set DEBUG=1 when a debug build should write NppMenuScripts-debug.log by default.
rem menu.json "debug": true/false overrides this default.
if not defined DEBUG set DEBUG=0

if not "%DEBUG%"=="0" if not "%DEBUG%"=="1" (
  echo DEBUG must be 0 or 1.
  exit /b 1
)

if not exist build mkdir build
if not exist third_party\cJSON.c (
  echo Missing third_party\cJSON.c
  echo Run get-cjson.bat first.
  exit /b 1
)
if not exist third_party\cJSON.h (
  echo Missing third_party\cJSON.h
  echo Run get-cjson.bat first.
  exit /b 1
)

rem Recent MinGW-w64 CRTs need CRT_fp10.o when linking a DLL that uses fenv.h.
for /f "delims=" %%I in ('g++ -print-file-name^=CRT_fp10.o') do set "CRT_FP10=%%I"
set "CRT_FP10_ARG="
if exist "%CRT_FP10%" set "CRT_FP10_ARG=%CRT_FP10%"

windres src\resource.rc build\resource.o
if errorlevel 1 exit /b %errorlevel%

g++ -m64 -std=c++17 -Oz -ffunction-sections -fdata-sections -s -shared -static -static-libgcc -static-libstdc++ ^
  -DNPPMENUSCRIPTS_DEBUG_DEFAULT=%DEBUG% ^
  -Isrc -Ithird_party ^
  src/main.cpp third_party/cJSON.c build/resource.o %CRT_FP10_ARG% ^
  -o build/NppMenuScripts.dll ^
  -Wl,--gc-sections -luser32 -lgdi32 -lkernel32 -lcomdlg32 -lcomctl32 -lshell32 -lole32

if errorlevel 1 exit /b %errorlevel%
echo Built build\NppMenuScripts.dll (DEBUG=%DEBUG%)
endlocal
