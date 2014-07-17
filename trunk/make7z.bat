@echo off
del /q *.7z
setlocal
set d=c:\l2ph-mod
cd /d %d%

md l2ph-mod
cd l2ph-mod
copy /y "%d%\build\*.exe" .
copy /y "%d%\build\*.dll" .
md Logs
md Plugins
md Scripts
md Settings
cd Settings
md ru
md en

copy /y "%d%\build\settings\ru\*.ini" "ru"
copy /y "%d%\build\settings\en\*.ini" "en"
copy /y "%d%\build\settings\*.ini" "."

del /q windows.ini
del /q options.ini

cd /d %d%
>rev.tmp svnversion
<rev.tmp set /p rev=
del /q rev.tmp
"C:\Program Files\7-Zip\7z" a -r l2ph-modr%rev%.7z l2ph-mod
rd /s /q l2ph-mod
endlocal

