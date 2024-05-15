import socket
import threading

PORT = 5555
HEADER = 64
FORMAT = "utf-8"
DISCONNECT_MESSAGE = "!DIS"
SERVER = "192.168.1.16"

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((SERVER, PORT))
print("Client Connected!")
def send_message(msg):
    message = msg.encode(FORMAT)
    msg_len = len(message)
    send_length = str(msg_len).encode(FORMAT)
    send_length += b' ' * (HEADER - len(send_length))
    print("Send length is", send_length)
    client.send(send_length)
    client.send(message)

def receive_message():
    connected = True
    while connected:
        msg_len = client.recv(HEADER).decode(FORMAT)
        print(f"Got message for server {msg_len}")
        if msg_len:
            msg_len = int(msg_len)
            msg = client.recv(msg_len).decode(FORMAT)
            if msg == DISCONNECT_MESSAGE:
                connected = False
            print(f"[SERVER]: {msg}")


receive_thread = threading.Thread(target=receive_message)
receive_thread.start()

while True:
    data = input("Enter function:- ")
    send_message(data)