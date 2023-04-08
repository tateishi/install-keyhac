@echo off

rem setup variables.

set URL="http://crftwr.github.io/keyhac/download/keyhac_182.zip"
set ARCHIVE="keyhac_182.zip"
set ARCHIVE_DIR="keyhac_182"
set DEST=%USERPROFILE%\Apps\keyhac_2
set DEST_DIR=%USERPROFILE%\Apps

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

rem del %ARCHIVE%
del %ARCHIVE%

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
