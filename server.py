import socket
import threading
import time
import server_functions as sf
from obswebsocket import obsws, requests

# Global Variables 

PORT = 5555
SERVER = socket.gethostbyname(socket.gethostname())
HEADER = 64
ADDR = (SERVER, PORT)
FORMAT = "utf-8"
DISCONNECT_MESSAGE = "!DIS"
OBS_CONNECTION = False

# Socket Settings
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(ADDR)
clients = [] 
obs_client = None

def disconnect_obs_handler():
    OBS_CONNECTION = False
    
def send_data(client, msg):
    client.send(msg)

def handle_client(con, addr):
    print(f"[NEW CONNECTION] From {addr}")
    clients.append(con) 
    connected = True
    send_data(con, get_data().encode(FORMAT))
    while connected:
        msg_len = con.recv(HEADER).decode(FORMAT)
        if msg_len:
            msg_len = int(msg_len)
            msg = con.recv(msg_len).decode(FORMAT)
            response = None
            if msg == "/start_recording":
                response = sf.start_recording()
            elif msg == "/stop_recording":
                response = sf.stop_recording()
            elif msg == "/stop_streaming":
                response = sf.stop_streaming()
            elif msg == "/remove_presenter":
                response = sf.remove_presenter_screen()
            elif msg == "/remove_verse_view":
                response = sf.remove_verse_view_screen()
            elif str(msg).find("/set_scene") == 0:
                scene = str(msg).split("?")[1]
                response = sf.set_current_scene(scene)
            elif str(msg).find("/send_notification") == 0:
                message = str(msg).split("?")[1]
                response = sf.send_notification(message)
            elif str(msg).find("/send_pop_up_notification") == 0:
                message = str(msg).split("?")[1]
                response = sf.send_pop_up_notification(message)
            elif msg == DISCONNECT_MESSAGE:
                connected = False
                print(f"[DISCONNECT] {addr}")
                clients.remove(con) 
                break
            else:
                print(f"[GOT MESSAGE FROM CLIENT {addr}, {msg}]")
                continue
            send_data(con, response.encode(FORMAT))


    con.close()

def get_data():
    return sf.get_data()

def updates_handler():
    last_data = None
    counter = 0
    while True:
        if counter == 0:
            counter = counter+1
            last_data = get_data()
            continue
        data = get_data()
        if last_data != data:
            last_data = data
            for client in clients:
                send_data(client, get_data().encode(FORMAT))
                continue
        time.sleep(0.1)

            

def start():
    print(f"[SERVER IS LISTENING ON {ADDR}]")
    server.listen()

    # Start the periodic message sending thread
    updater = threading.Thread(target=updates_handler)
    updater.start()

    while True:
        con, addr = server.accept()
        thread = threading.Thread(target=handle_client, args=(con, addr))
        thread.start()
        print(f"[ACTIVE CONNECTIONS]: {threading.active_count() - 2}")  # -2 to exclude the main and send threads

if __name__ == "__main__":
    # connect_to_obs()
    start()