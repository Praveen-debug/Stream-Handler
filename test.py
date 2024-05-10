import requests
import time

url = "http://192.168.1.43:5000"
while True:
   response = requests.get(url + "/presenting")
   print(response.text)
   response = requests.get(url + "/presenter")
   print(response.text)
   response = requests.get(url + "/get_streaming_status")
   print(response.text)
   response = requests.get(url + "/get_recording_status")
   print(response.text)
   response = requests.get(url + "/get_current_scene")
   print(response.text)
   response = requests.get(url + "/get_open_windows")
   print(response.text)
   response = requests.get(url + "/get_scenes")
   print(response.text)
   time.sleep(3)