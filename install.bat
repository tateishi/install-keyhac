@echo off

setlocal

rem setup variables.

set MYAPP=%LOCALAPPDATA%\MyApp
set TMP_DIR=%TMP%\keyhac
set RETURN_DIR=%cd%

set URL="http://crftwr.github.io/keyhac/download/keyhac_182.zip"
set ARCHIVE="keyhac_182.zip"
set ARCHIVE_DIR="keyhac_182"
set DEST=%MYAPP%\keyhac
set DEST_DIR=%USERPROFILE%\Apps

set CONFIG_DIR=%USERPROFILE%\wks\MyConfigs
set CONFIG_REPO=https://github.com/tateishi/keyhac-config.git
set REPO_DIR=keyhac-config

rem create working directory and change current directory
if not exist %TMP_DIR% (
    echo mkdir %TMP_DIR%
    mkdir %TMP_DIR%
)
echo chdir %TMP_DIR%
chdir %TMP_DIR%

rem download archive file.
rem echo curl -O %URL%
curl -O %URL%

rem remove directory to expand.
if exist %ARCHIVE_DIR% (
    rem echo rmdir /s /q %ARCHIVE_DIR%
    rmdir /s /q %ARCHIVE_DIR%
)

rem expand archive.
rem echo %DEST%
rem echo call powershell -command "Expand-Archive %ARCHIVE%"
call powershell -command "Expand-Archive %ARCHIVE%"

rem remove directory to install.
if exist %DEST% (
    rem echo %DEST% exists.
    rem echo rmdir /s /q %DEST%
    rmdir /s /q %DEST%
)

rem install keyhac
rem echo xcopy %ARCHIVE_DIR%\keyhac %DEST% /s /e /q /i
xcopy %ARCHIVE_DIR%\keyhac %DEST% /s /e /q /i

rem remove directory expanded
if exist %ARCHIVE_DIR% (
    rem echo rmdir /s /q %ARCHIVE_DIR%
    rmdir /s /q %ARCHIVE_DIR%
)

rem del %ARCHIVE%
del %ARCHIVE%

rem clone config from github
if not exist %CONFIG_DIR% (
    echo mkdir %CONFIG_DIR%
    mkdir %CONFIG_DIR%
)
echo chdir %CONFIG_DIR%
chdir %CONFIG_DIR%
echo git clone %CONFIG_REPO%
git clone %CONFIG_REPO%

rem copy config file to app dir
echo chdir %REPO_DIR%
chdir %REPO_DIR%
echo copy config.py %DEST%
copy config.py %DEST%

rem chdir to original directory

echo chdir %RETURN_DIR%
chdir %RETURN_DIR%

rem install shortcut to startup folder
wscript startup.vbs

endlocal
