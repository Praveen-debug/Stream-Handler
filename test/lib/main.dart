import 'dart:async';
import 'package:flutter/material.dart';
import 'socket.dart'; // Import the SocketConnection class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  final SocketConnection _socketConnection =
      SocketConnection('192.168.1.4', 5555);
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Future<void> connect_to_server(SocketConnection _socketConnection) async {
  print("I started");
  Future<bool> conn = Future(() => false);
  while (conn == false) {
    conn = _socketConnection.connect();
    if (conn == true) {
      print("Connected");
      break;
    } else {
      print("Not connected, Trying Again");
    }
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _socketConnection.sendDataToServer('Hello, server!');
          },
          child: Text('Send Data'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _socketConnection.closeConnection();
    super.dispose();
  }
}
