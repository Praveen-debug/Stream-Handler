import 'package:flutter/material.dart';
import 'socket.dart'; // Import the SocketConnection class

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final socketConnection = SocketConnection('192.168.1.4', 5555);
  bool isConnected = false;
  String data = "";

  @override
  void initState() {
    super.initState();
    socketConnection.setConnectionCallback(handleConnectionStatus);
    socketConnection.setServerDataCallback(handleData);
    socketConnection.connect();
  }

  void handleConnectionStatus(bool isConnected) {
    setState(() {
      this.isConnected = isConnected;
    });
  }

  void handleData(String data) {
    setState(() {
      this.data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Socket Connection Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                isConnected ? 'Connected' : 'Not Connected',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                data,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
