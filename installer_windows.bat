@echo off
echo Downloading package from github...
curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | findstr "tag_name" > temp
set /p version=<temp
del temp
set version=%version:~15,6%
set version_num=%version:~1%
set LOCATION=https://github.com/kithuto/Youtube-to-Spotify-automatization/archive/%version%.zip
curl -L -o Youtube_to_spotify.zip %LOCATION%
echo Unziping file...
tar -xf Youtube_to_spotify.zip
del Youtube_to_spotify.zip
xcopy Youtube-to-Spotify-automatization-%version_num%\Youtube_to_spotify Youtube_to_spotify /E /H /C /I
rmdir /s /q Youtube-to-Spotify-automatization-%version_num%
echo Checking if Python is installed...
py -V > vers
if errorlevel 1 (
   set "v=Python 2"
) else (
    set /p v=<vers
)
del vers
if not "%v:~0,8%" == "Python 3" (
    echo Installing Python...
    call Youtube_to_spotify\python\python-3.7.9-amd64.exe
)
echo Installing requirements...
pip install requests
pip install youtube_dl --upgrade
pip install selenium
pip install cryptography
echo Creating executable...
echo @echo off> youtube_to_spotify.bat
echo echo Loading...>> youtube_to_spotify.bat
echo call Youtube_to_spotify/upgrader.bat>> youtube_to_spotify.bat
echo cd Youtube_to_spotify>> youtube_to_spotify.bat
echo py youtube_to_spotify.py>> youtube_to_spotify.bat
echo set /p r=Press enter to close the program. >> youtube_to_spotify.bat
cd Youtube_to_spotify
rmdir /s /q python
echo Youtube to spotify installed successfully!
echo version = '%version%'>> program_version.py
set correct=0
:while
if %correct% == 0 (
    set /p user=Spotify user (user id^): 
    set /p password=Password: 
)
if %correct% == 0 (
    echo Checking user and pass in spotify (logging in^)...
    echo spotify_id = '%user%'> secret.py
    call py pass_encrypter.py %password%
    call py test_user_pass.py
)
if %correct% == 0 (
    if %ERRORLEVEL% == 0 (
        set correct=1
    ) else ( 
        echo Incorrect user or password!
    )
    goto :while
)
echo Correct user and password!
echo Click youtube_to_spotify.bat to execute the program
set /p a=Press enter to close the installer 
taskkill /im cmd.exe