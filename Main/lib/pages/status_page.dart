import 'dart:convert';

import "package:flutter/material.dart";
import 'package:tdf_media_handler/components/client.dart';
import 'package:tdf_media_handler/components/controls.dart';
import 'package:tdf_media_handler/components/obs_box.dart';
import 'package:tdf_media_handler/components/server_box.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final socketConnection = SocketConnection('192.168.1.4', 5555);
  bool isConnected = false;
  Map<String, dynamic>? data;
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
    print("data is $data");
    try {
      setState(() {
        this.data = jsonDecode(data);
      });
      String windowsList = this.data?["windows"];
      List<String> windows = windowsList.split(r"', '");
      print(windows[2]);
    } catch (e) {
      print("Code in fire $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("This data is");
    print(this.data);
    return Scaffold(
      backgroundColor: Colors.black,
      body: isConnected
          ? Center(
              child: SingleChildScrollView(
                // Wrap the Column in a scrollable view
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ServerBox(
                      isConnected: isConnected,
                      data: data,
                    ),
                    ObsBox(
                      isConnected: isConnected,
                      data: data,
                      socketConnection: socketConnection,
                    ),
                    ControlBox(
                      isConnected: isConnected,
                      data: data,
                      socketConnection: socketConnection,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                        left: 25,
                        top: 30,
                        bottom: 30,
                      ),
                      child: Text(
                        "The app wasn't able to connect to the server. Please check if the server is up or not. If the problem persists, please inform the devs.",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: 300,
                    child: Row(
                      // Use a Row to arrange elements horizontally
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Center elements within the Row
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: 15,
                            left: 25,
                            top: 30,
                            bottom: 30,
                          ), // Adjust padding as needed
                          child: Text(
                            "Trying to reconnect",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
