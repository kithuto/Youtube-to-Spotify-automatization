LOCATION=$(curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | grep "tag_name")
version=${LOCATION:15:6}
py Youtube_to_spotify/version_checker.py $version
if [[ $? == 1 ]]
then cp Youtube_to_spotify/secret.py ./
rm -r Youtube_to_spotify
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
rm -r Youtube-to-Spotify-automatization-$version_num
rm Youtube_to_spotify/secret.py
cp secret.py Youtube_to_spotify
rm secret.py
cd Youtube_to_spotify
rm -r python
echo "version = '$version'" >> program_version.py
cd ../
fi