@echo off
curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | findstr "tag_name" > temp
set /p version=<temp
del temp
set version=%version:~15,6%
set version_num=%version:~1%
py Youtube_to_spotify/version_checker.py %version%
set download=%ERRORLEVEL%
if %download% == 1 (
    copy Youtube_to_spotify\secret.py
    echo Downloading package from github...
    set LOCATION=https://github.com/kithuto/Youtube-to-Spotify-automatization/archive/%version%.zip
)
if %download% == 1 (
    curl -L -o Youtube_to_spotify.zip %LOCATION%
    echo Unziping file...
    tar -xf Youtube_to_spotify.zip
    del Youtube_to_spotify.zip
    xcopy Youtube-to-Spotify-automatization-%version_num%\Youtube_to_spotify Youtube_to_spotify /E /H /C /I /Y
    rmdir /s /q Youtube-to-Spotify-automatization-%version_num%
    copy secret.py Youtube_to_spotify
    rmdir /s /q Youtube_to_spotify\python
    echo version = '%version%' > Youtube_to_spotify\program_version.py
    del secret.py
    start youtube_to_spotify.bat
)