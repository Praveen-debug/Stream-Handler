from obswebsocket import obsws, requests
import pygetwindow as gw
import pyautogui as py
from notifypy import Notify
import threading
import subprocess
import threading
import time

OBS = False
OBS_CLIENT = obsws("192.168.1.16", 4444, "Iphonex")

def connect_to_obs():
    global OBS, OBS_CLIENT
    while True:
        try:
            OBS_CLIENT.connect()
            OBS = True
            break
        except Exception as e:
            pass

def disconnect_obs(e):
    global OBS
    OBS = False
    connect_obs = threading.Thread(target=connect_to_obs)
    connect_obs.start()

OBS_CLIENT.on_disconnect = disconnect_obs
disconnect_obs("E")

def get_recording_status():
    try:
        response = OBS_CLIENT.call(requests.GetRecordingStatus())
        return str(response.getIsRecording())
    except:
        global obs_connected
        obs_connected = False
        return False


def get_streaming_status():
    
    try:
        response = OBS_CLIENT.call(requests.GetStreamingStatus())
        return str(response.getStreaming())
    except:
        return False
        
def get_current_scene():
    
    try:
        response = OBS_CLIENT.call(requests.GetCurrentScene())
        return str(response.getname())
    except Exception as e:
        print("Ayo Error", e)
        return False

def set_current_scene(scene_name):
    
    try:
        response = OBS_CLIENT.call(requests.SetCurrentScene(**{'scene-name': scene_name}))
        print("Yo response is", response)
        return str(response.getStatus())
    except Exception as e:
        print("Error Occured")
        return False


def get_scenes():
    
    try:
        response = OBS_CLIENT.call(requests.GetSceneList())
        scenes = []
        for scene in response.getscenes():
            scenes.append(scene["name"])
        return scenes
    except Exception as e:
        print("Yo error is ", e)
        return False
    
def start_recording():
    try:
        response = OBS_CLIENT.call(requests.StartRecording())
        return str(response.getstatus())
    except Exception as e:
        return False
    
def stop_recording():
    try:
        response = OBS_CLIENT.call(requests.StopRecording())
        return str(response.getstatus())
    except Exception as e:
        return False

def stop_streaming():
    try:
        response = OBS_CLIENT.call(requests.StopStreaming())
        return str(response.getStatus())
    except Exception as e:
        return False

def get_open_windows():
    windows = []

    cmd = 'powershell "gps | where {$_.MainWindowTitle } | select Description'
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    counter = 0
    for line in proc.stdout:
        if line.rstrip():
            if counter >= 2:
                output = line.decode().rstrip()
                windows.append(str(output))
            else:
                counter = counter + 1
    return windows

def get_open_windows_local():
    windows = []

    for window in py.getAllWindows():
        if window.title  != "":
            windows.append(window.title)
    return windows


def presenter():
    for i in get_open_windows_local():
        if i == "Presenter":
            return True
    return False
    
        

def presenting():
    for i in get_open_windows_local():
        if i == "Presenter Display (Main Audience Output)":
            return True
    return False



def remove_presenter_screen():
    process =  subprocess.Popen(["python", "remove_presenter_screen.py"], stdout=subprocess.PIPE)
    output, err = process.communicate()
    captured_output = output.decode()
    print("Data is ", captured_output.rstrip())
    return str(str(captured_output).rstrip())
 


def remove_verse_view_screen():
    process =  subprocess.Popen(["python", "remove_verse_view_screen.py"], stdout=subprocess.PIPE)
    output, err = process.communicate()
    captured_output = output.decode()
    return str(str(captured_output).rstrip())

def alert(message):
    py.alert(message)


def send_pop_up_notification(message):
    threading.Thread(target=alert, args=(message,)).start()
    return "Sent pop up notification"




def send_notification(message):
    notification = Notify()
    notification.title = f"Notification"
    notification.message = f"{message}"
    notification.icon = "E:/Chruch Logo/Ico image of logo.ico"
    notification.application_name = 'Tdf Media Handler'

    notification.send()
    return "Sent notification"

def get_data():
    if OBS:
        data = {
            "obs": "true",
            "recording": str(get_recording_status()).lower(),
            "streaming": str(get_streaming_status()).lower(),
            "current_scene": str(get_current_scene()).lower(),
            "scenes": str(get_scenes()).lower(),
            "windows": str(get_open_windows()).lower(),
            "presenter": str(presenter()).lower(),
            "presenting": str(presenting()).lower(),
        }
        return data
    else:
        data = {
            "obs": "false",
            "windows": str(get_open_windows()).lower(),
            "presenter": str(presenter()).lower(),
            "presenting": str(presenting()).lower(),
        }
        return data

