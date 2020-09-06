import json
import requests
from selenium import webdriver
import time
import sys
from youtube_dl import YoutubeDL
from secret import spotify_id, spotify_pass

class createPlaylist:
    
    def __init__(self):
        self.spotify_token = self.get_spotify_token()
        self.songs_list = []
        self.playlist_id = ""
        self.num_songs = 0

    def get_spotify_token(self):
        options = webdriver.ChromeOptions()

        options.add_argument("headless")

        driver = webdriver.Chrome(executable_path=r"drivers/chromedriver.exe",options=options)
        driver.get('https://developer.spotify.com/console/post-playlists/')

        get_token = driver.find_element_by_xpath('//*[@id="console-form"]/div[4]/div/span/button')
        get_token.click()

        finished = False
        while not finished:
            try:
                modify_public = driver.find_element_by_xpath('//*[@id="oauth-modal"]/div/div/div[2]/form/div[1]/div/div/div[1]/div/label/span')
                modify_public.click()
                finished = True
            except:
                pass

        modify_private = driver.find_element_by_xpath('//*[@id="oauth-modal"]/div/div/div[2]/form/div[1]/div/div/div[2]/div/label/span')
        modify_private.click()

        submit = driver.find_element_by_xpath('//*[@id="oauthRequestToken"]')
        submit.click()

        user = driver.find_element_by_xpath('//*[@id="login-username"]')
        user.send_keys(spotify_id)

        password = driver.find_element_by_xpath('//*[@id="login-password"]')
        password.send_keys(spotify_pass)

        log_in = driver.find_element_by_xpath('//*[@id="login-button"]')
        log_in.click()
        
        finished = False
        while not finished:
            try:
                token = driver.find_element_by_xpath('//*[@id="oauth-input"]').get_attribute('value')
                finished = True
            except:
                pass
        
        driver.close()

        return token

    def create_playlist(self, name="Youtube playlist", description="Playlist de youtube", is_public=True):
        request_body = json.dumps({
            "name": name,
            "description": description,
            "public": is_public
        })

        query = "https://api.spotify.com/v1/users/{}/playlists".format(spotify_id)
        response = requests.post(
            query,
            data=request_body,
            headers={
                "Content-Type": "application/json",
                "Authorization": "Bearer {}".format(self.spotify_token)
            }
        )
        response_json = response.json()

        return response_json["id"]

    def get_playlist_songs_urls(self, playlist_url):
        result = YoutubeDL({}).extract_info(playlist_url, download=False)
        songs = result['entries']
        print("Adding songs to the spotify list...")
        for song in songs:
            song, track, artist = self.process_song_title(song['title'])
            url = self.get_spotify_url(track, artist, song)
            if url != None:
                self.songs_list.append(url)
                self.num_songs +=1

    def get_spotify_url(self, song_name, artist, fullname):
        if song_name != "" and artist != "":
            query = "https://api.spotify.com/v1/search?query=track%3A{}+artist%3A{}&type=track&offset=0&limit=20".format(
                song_name,
                artist
            )
            response = requests.get(
                query,
                headers={
                    "Content-Type": "application/json",
                    "Authorization": "Bearer {}".format(self.spotify_token)
                }
            )
            response_json = response.json()
            if response_json["tracks"]["total"] != 0:
                songs = response_json["tracks"]["items"]

                # only use the first song
                url = songs[0]["uri"]

                return url

            query = "https://api.spotify.com/v1/search?query=track%3A{}+artist%3A{}&type=track&offset=0&limit=20".format(
                artist,
                song_name
            )
            response = requests.get(
                query,
                headers={
                    "Content-Type": "application/json",
                    "Authorization": "Bearer {}".format(self.spotify_token)
                }
            )
            response_json = response.json()
            if response_json["tracks"]["total"] != 0:
                songs = response_json["tracks"]["items"]

                # only use the first song
                url = songs[0]["uri"]

                return url
        
        query = "https://api.spotify.com/v1/search?q={}&type=track&offset=0&limit=20".format(
            fullname
        )
        response = requests.get(
            query,
            headers={
                "Content-Type": "application/json",
                "Authorization": "Bearer {}".format(self.spotify_token)
            }
        )
        response_json = response.json()
        if response_json["tracks"]["total"] != 0:
            songs = response_json["tracks"]["items"]

            # only use the first song
            url = songs[0]["uri"]

            return url

        return None

    def process_song_title(self, song):
        if '(' or '[' in song:
            i = 0
            for char in song:
                if char == '(' or char == '[':
                    pos = i 
                    break
                i += 1
        
        song = song[0:pos]
        artist = ""
        track = ""

        if ' x ' in song:
            song = song.replace(" x ", ", ")

        if ' y ' in song:
            song = song.replace(" y ", ", ")

        if ' & ' in song:
            song = song.replace(" & ", ", ")

        if '-' or '|' in song:
            i = 0
            for char in song:
                if char == '-' or char == '|':
                    pos = i 
                    break
                i += 1
            artist = song[0:pos]
            track = song[pos+1:-1]

        if ' Ft.' in artist:
            artist = artist.replace(" Ft.", ", ")
            
        if ' ft.' in artist:
            artist = artist.replace(" ft.", ", ")
        
        if ' Feat.' in artist:
            artist = artist.replace(" Feat.", ", ")
        
        return song, track, artist

    def new_playlist(self, playlist_url, name, description):
        self.playlist_id = self.create_playlist(name, description)
        self.get_playlist_songs_urls(playlist_url)

        request_data = json.dumps(self.songs_list)

        query = "https://api.spotify.com/v1/playlists/{}/tracks".format(self.playlist_id)

        response = requests.post(
            query,
            data=request_data,
            headers={
                "Content-Type": "application/json",
                "Authorization": "Bearer {}".format(self.spotify_token)
            }
        )
        return response


if __name__ == '__main__':
    print('Name for the playlist in spotify:')
    name = input()
    print('Description:')
    description = input()
    print("Playlist Youtube link:")
    playlist = input()
    print("Logging in with the spotify user "+spotify_id+"...")
    cp = createPlaylist()
    print("Creating spotify list...")
    cp.new_playlist(playlist, name, description)
    sys.exit(cp.num_songs)