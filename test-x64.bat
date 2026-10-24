@echo off
setlocal

if not exist build mkdir build
g++ -std=c++17 -Wall -Wextra -Werror tests\core_logic_tests.cpp -o build\core_logic_tests.exe
if errorlevel 1 exit /b %errorlevel%

build\core_logic_tests.exe
if errorlevel 1 exit /b %errorlevel%

echo All NppMenuScripts unit tests passed.
endlocal
