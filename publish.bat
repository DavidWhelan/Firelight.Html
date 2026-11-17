@echo off
setlocal

REM Clean and create output directory
if exist .build rmdir /s /q .build
mkdir .build

REM Pack projects
dotnet pack src\Firelight.Html\Firelight.Html.fsproj -c Release -o .build

echo.
echo Done! NuGet packages are in the .build folder.
echo.
pause
