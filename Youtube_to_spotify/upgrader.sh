LOCATION=$(curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | grep "tag_name")
version=${LOCATION:15:6}
py Youtube_to_spotify/version_checker.py $version
if [[ $? == 1 ]]
then cp Youtube_to_spotify/secret.py ./
echo "Downloading package from github..."
LOCATION=$(curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | grep "tag_name" | awk '{print "https://github.com/kithuto/Youtube-to-Spotify-automatization/archive/" substr($2, 2, length($2)-3) ".zip"}')
LOCATION_V=$(curl -s https://api.github.com/repos/kithuto/Youtube-to-Spotify-automatization/releases/latest | grep "tag_name")
version=${LOCATION_V:15:6}
version_num=${version:1}
curl -L -o Youtube_to_spotify.zip $LOCATION
echo "Unziping file..."
unzip Youtube_to_spotify.zip
rm Youtube_to_spotify.zip
rm -r Youtube-to-Spotify-automatization-$version_num
cp -r Youtube-to-Spotify-automatization-$version_num/Youtube_to_spotify ./
cp secret.py Youtube_to_spotify
rm secret.py
rm -r Youtube_to_spotify/python
echo "version = '$version'" >> Youtube_to_spotify/program_version.py
fi