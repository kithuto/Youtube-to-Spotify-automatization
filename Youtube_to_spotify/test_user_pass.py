from selenium import webdriver
from secret import spotify_id, spotify_pass
import sys
import time

options = webdriver.ChromeOptions()

options.add_argument("headless")

driver = webdriver.Chrome(executable_path=r"drivers/chromedriver.exe",options=options)
driver.get('https://accounts.spotify.com/es/login?continue=https:%2F%2Fwww.spotify.com%2Fes%2Faccount%2Foverview%2F')

user = driver.find_element_by_xpath('//*[@id="login-username"]')
user.send_keys(spotify_id)

password = driver.find_element_by_xpath('//*[@id="login-password"]')
password.send_keys(spotify_pass)

submit = driver.find_element_by_xpath('//*[@id="login-button"]')
submit.click()

time.sleep(1)
alert = None
try:
    alert = driver.find_element_by_xpath('//*[@id="app"]/body/div[1]/div[2]/div/div[2]/div/p')
except:
    pass

if(alert):
    sys.exit(1)
else:
    sys.exit(0)