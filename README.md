# OBS Remote Control

OBS Remote Control is an innovative solution that allows wireless control of the popular Open Broadcaster Software (OBS) recording and streaming functions using an Android device. It aims to simplify the streaming experience for IRL (In Real Life) streamers, small-scale streamers (such as weddings, churches, and NGOs), and anyone who needs to control their streams remotely.

NOTE:-
OBS Remote Control is a custom solution developed for a client, so it was customized accordingly. Please feel free to make changes to it. Thanks.

## Features

- Change scenes in OBS
- Start or stop recording
- Start or stop streaming
- Perform operations like stopping a presentation
- Control OBS functions from an Android device wirelessly

## Architecture

The project consists of two main components:

1. **Backend (Python)**: The backend is built using Python and is responsible for communicating with OBS and performing the desired functions. It creates a socket for the Android app to connect and send commands.

2. **Android App (Flutter)**: The Android app is developed using Flutter, providing a user-friendly interface for controlling OBS functions remotely. It connects to the Python backend through the socket and sends commands based on user input.

## Getting Started

### Prerequisites

- Python 3.11.8
- Flutter 3.19.6
- OBS Studio 30.1.2

