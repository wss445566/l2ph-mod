@echo off
setlocal

pushd c:\l2ph-mod
if %errorlevel%==1 (
  echo path not found
  pause
  exit /b 1
)
if not exist build\l2ph.exe (
  echo l2.exe not found
  pause
  exit /b 2
)
>rev.tmp svnversion
<rev.tmp set /p rev=
del /q rev.tmp

echo %rev% | findstr ":"
if %errorlevel%==0 (
  echo update svn first
  pause
  exit /b 3
)

::del /q *.7z

md l2ph-mod
cd l2ph-mod
copy /y "..\build\*.exe" .
copy /y "..\build\*.dll" .
md Logs
md Plugins
md Scripts
md Settings
cd Settings
md ru
md en

copy /y "..\..\build\settings\ru\*.ini" "ru"
copy /y "..\..\build\settings\en\*.ini" "en"
copy /y "..\..\build\settings\*.ini" "."

del /q windows.ini
del /q options.ini

cd ..\..
"C:\Program Files\7-Zip\7z" a -r l2ph-modr%rev%.7z l2ph-mod
rd /s /q l2ph-mod
popd
endlocal

