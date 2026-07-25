@echo off
setlocal

title 192 GiB Windows Configuration Tool

set "DISK=1"
set "SCRIPT=%TEMP%\diskpart_script.txt"

echo ===================================================
echo        192 GiB Windows Configuration Tool
echo ===================================================
echo.
echo WARNING:
echo This will COMPLETELY ERASE Disk %DISK%.
echo Make absolutely sure the correct disk is selected.
echo.
pause

echo Generating DiskPart script...

(
    echo select disk %DISK%
    echo clean
    echo convert gpt
    echo create partition efi size=2048
    echo format quick fs=fat32 label="System"
    echo create partition msr size=128
    echo create partition primary size=196608
    echo format quick fs=ntfs label="Windows"
    echo create partition primary size=1024
    echo format quick fs=ntfs label="Recovery"
    echo set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac
    echo gpt attributes=0x8000000000000001
) > "%SCRIPT%"

echo.
echo Running DiskPart...
diskpart /s "%SCRIPT%"

if exist "%SCRIPT%" del "%SCRIPT%"

echo.
echo ===================================================
echo           Disk configuration complete.
echo ===================================================
echo.
pause
exit /b
