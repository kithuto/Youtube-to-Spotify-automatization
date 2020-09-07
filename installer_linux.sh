echo "Downloading package from github..."
LOCATION=$(curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | grep "tag_name" | awk '{print "https://github.com/kithuto/Youtube-to-Spotify-automatization/archive/" substr($2, 2, length($2)-3) ".zip"}')
LOCATION_V=$(curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | grep "tag_name")
version=${LOCATION_V:15:6}
version_num=${version:1}
curl -L -o Youtube_to_spotify.zip $LOCATION
echo "Unziping file..."
unzip Youtube_to_spotify.zip
rm Youtube_to_spotify.zip
cp -r Youtube-to-Spotify-automatization-$version_num/Youtube_to_spotify ./
rm Youtube-to-Spotify-automatization-$version_num
echo "Checking if Python is installed..."
pyv="$(py -V)"
if [[ $pyv != "Python 3."* ]]
then echo installing Python...
Youtube_to_spotify/python/python-3.7.9-amd64.exe
fi
echo "Installing requirements..."
pip install requests
pip install youtube_dl
pip install selenium
echo "Creating executable..."
echo "echo Loading..." >> youtube_to_spotify.sh
echo "Youtube_to_spotify/upgrader.sh" >> youtube_to_spotify.sh
echo "cd Youtube_to_spotify" >> youtube_to_spotify.sh
echo "py youtube_to_spotify.py" >> youtube_to_spotify.sh
echo "echo $? songs added to the Spotify list!" >> youtube_to_spotify.sh
echo "read" >> youtube_to_spotify.sh
echo "read -p 'Press enter to close the program. ' r" >> youtube_to_spotify.sh
cd Youtube_to_spotify
rm -r python
echo "Youtube to spotify installed successfully!"
echo "version = '$version'" > program_version.py
correct=0
while [ $correct == 0 ]
do 
read -p 'Spotify user (user id): ' user
read -p 'Password: ' password
echo "Checking user and pass in spotify..."
echo "spotify_id = '$user'" > secret.py
py pass_encrypter.py $password
py test_user_pass.py
if [[ $? == 0 ]]
then correct=1
else echo "Incorrect user or password!"
fi
done
echo "Correct user and password!"
echo "Click youtube_to_spotify.bat to execute the program"
read -p 'Press enter to exit the installer ' a