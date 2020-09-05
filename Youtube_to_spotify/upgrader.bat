@echo off
curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | findstr "tag_name" > temp
set /p version=<temp
del temp
set version=%version:~15,6%
py Youtube_to_spotify/version_checker.py %version%
if %ERRORLEVEL% == 1 (
    copy Youtube_to_spotify/secret.py
    rmdir /s /q Youtube_to_spotify
    echo Downloading package from github...
    curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | findstr "tag_name" > temp
    set /p version=<temp
    del temp
    set version=%version:~15,6%
    set version_num=%version:~1%
    set LOCATION=https://github.com/kithuto/Youtube-to-Spotify-automatization/archive/%version%.zip
    curl -L -o Youtube_to_spotify.zip %LOCATION%
    tar -xf Youtube_to_spotify.zip
    del Youtube_to_spotify.zip
    xcopy Youtube-to-Spotify-automatization-%version_num%\Youtube_to_spotify Youtube_to_spotify /E /H /C /I
    rmdir Youtube-to-Spotify-automatization-%version_num%
    del Youtube_to_spotify/secret.py
    copy secret.py Youtube_to_spotify
    del secret.py
    cd Youtube_to_spotify
    echo version = '%version%' > program_version.py
    cd ../
)