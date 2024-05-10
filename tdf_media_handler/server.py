from obswebsocket import obsws, requests  # Ensure obswebsocket is installed
import pygetwindow as gw
import pyautogui as py
from notifypy import Notify
from flask import Flask, request, jsonify
import threading
import subprocess

app = Flask(__name__)

obs_client = ""
obs_connected = False

@app.route("/connect_to_obs")
def connect_to_obs():
    global obs_client, obs_connected
    obs_client = obsws("192.168.1.5", 4444, "Iphonex")

    try:
        obs_client.connect()
        obs_connected = True
        return jsonify({"Status": "true", "Error": "false", "Data": "Connected"}), 200
    except Exception as e:
        obs_connected = False
        return jsonify({"Status": "false", "Error": "true", "Data": f"Not connected error ${str(e)}"}), 200


@app.route("/is_connected_to_obs")
def is_connected_to_obs():
    return jsonify({"Status": "false", "Error": str(obs_connected).lower(), "Data": "true"}), 200

@app.route("/get_recording_status")
def get_recording_status():
    
    try:
        response = obs_client.call(requests.GetRecordingStatus())
        return jsonify({"Status": "false", "Error": "false", "Data": str(response.getIsRecording()).lower()}), 200
    except:
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200


@app.route("/get_streaming_status")
def get_streaming_status():
    
    try:
        response = obs_client.call(requests.GetStreamingStatus())
        return jsonify({"Status": "false", "Error": "true", "Data": str(response.getStreaming()).lower()}), 200
    except:
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200
        

@app.route("/get_current_scene")
def get_current_scene():
    
    try:
        response = obs_client.call(requests.GetCurrentScene())
        return jsonify({"Status": "false", "Error": "true", "Data": response.getname()}), 200
    except Exception as e:
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200

@app.route("/set_current_scene/<scene_name>")
def set_current_scene(scene_name):
    
    try:
        response = obs_client.call(requests.SetCurrentScene(**{'scene-name': scene_name}))
        print("Yo response is", response)
        return jsonify({"Status": "false", "Error": "true", "Data": str(response.getStatus()).upper()}), 200
    except Exception as e:
        print("Error Occured")
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200


@app.route("/get_scenes")
def get_scenes():
    
    try:
        response = obs_client.call(requests.GetSceneList())
        print("Praveen", response.getscenes())
        scenes = [scene["name"] for scene in response.getscenes()]
        print("scnes is" + str(scenes) + "Type of scenes is")
        return jsonify({"Status": "true", "Error": "false", "Data": scenes}), 200
    except Exception as e:
        print("Yo error is ", e)
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200
    

@app.route("/start_recording")
def start_recording():
    try:
        response = obs_client.call(requests.StartRecording())
        return jsonify({"Status": "false", "Error": "true", "Data": str(response.getstatus()).upper()}), 200
    except Exception as e:
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200
    
@app.route("/stop_recording")
def stop_recording():
    try:
        response = obs_client.call(requests.StopRecording())
        return jsonify({"Status": "false", "Error": "true", "Data": str(response.getstatus()).upper()}), 200
    except Exception as e:
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200


@app.route("/stop_streaming")
def stop_streaming():
    try:
        response = obs_client.call(requests.StopStreaming())
        return jsonify({"Status": "false", "Error": "true", "Data": str(response.getStatus()).upper()}), 200
    except Exception as e:
        global obs_connected
        obs_connected = False
        return jsonify({"Status": "false", "Error": "OBS", "Data": "false"}), 200


@app.route("/get_open_windows")
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
                counter = counter + 1;
    return jsonify({"Status": "true", "Error": "false", "Data": windows}), 200

def get_open_windows_local():
    windows = []

    for window in py.getAllWindows():
        if window.title  != "":
            windows.append(window.title)
    return windows

@app.route("/presenter")
def presenter():
    for i in get_open_windows_local():
        if i == "Presenter":
            return jsonify({"Status": "true", "Error": "false", "Data": "true"}), 200 
    return jsonify({"Status": "true", "Error": "false", "Data": "false"}), 200
    
        
@app.route("/presenting")
def presenting():
    for i in get_open_windows_local():
        if i == "Presenter Display (Main Audience Output)":
            return jsonify({"Status": "true", "Error": "false", "Data": "true"}), 200 
    return jsonify({"Status": "true", "Error": "false", "Data": "false"}), 200


@app.route("/remove_presenter_screen")
def remove_presenter_screen():
    process =  subprocess.Popen(["python", "remove_presenter_screen.py"], stdout=subprocess.PIPE)
    output, err = process.communicate()
    captured_output = output.decode()
    print("Data is ", captured_output.rstrip())
    return jsonify({"Status": "true", "Error": "false", "Data": f"{str(str(captured_output).rstrip())}"}), 200
 

@app.route("/remove_verse_view_screen")
def remove_verse_view_screen():
    process =  subprocess.Popen(["python", "remove_verse_view_screen.py"], stdout=subprocess.PIPE)
    output, err = process.communicate()
    captured_output = output.decode()
    return jsonify({"Status": "true", "Error": "false", "Data": f"{str(captured_output).rstrip()}"}), 200

def alert(message):
    # MessageBox = ctypes.windll.user32.MessageBoxW
    # MessageBox(None, message, "Notification", 0)
    py.alert(message)

@app.route("/send_pop_up_notification")
def send_pop_up_notification():
    message = request.args.get('message')
    threading.Thread(target=alert, args=(message,)).start()
    return jsonify({"Status": "true", "Error": "false", "Data": "Sent pop up notification"}), 200



@app.route("/send_notification")
def send_notification():
    notification = Notify()
    message = request.args.get('message')
    notification.title = f"Notification"
    notification.message = f"{message}"
    notification.icon = "E:/Chruch Logo/Ico image of logo.ico"
    notification.application_name = 'Tdf Media Handler'

    notification.send()
    return jsonify({"Status": "true", "Error": "false", "Data": "Sent notification"}), 200

if __name__ == "__main__":
    app.app_context().push()
    connect_to_obs()
    app.run(debug=True, host='0.0.0.0')

