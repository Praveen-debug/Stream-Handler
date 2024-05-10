import "package:flutter/material.dart";
import 'package:tdf_media_handler/components/client.dart';
import 'package:tdf_media_handler/components/controls.dart';
import 'package:tdf_media_handler/components/obs_box.dart';
import 'package:tdf_media_handler/components/server_box.dart';
import 'dart:async';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  bool presenting = false;
  bool connected = false;
  bool presenter = false;
  bool live = false;
  bool recording = false;
  String current_scene = "";
  bool isLoading = true; // Loading state
  bool serverDown = true;
  List apps = [];
  List scenes = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    assingData();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      assingData();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> assingData() async {
    const timeoutDuration = Duration(seconds: 10);
    final rConnected =
        await BaseClientAPI().askInfo("/is_connected_to_obs").timeout(
              timeoutDuration,
              onTimeout: () => {},
            );
    setState(() {
      isLoading = false;
    });

    if (rConnected.toString() != "{Null}" && rConnected.toString() != "{}") {
      setState(() {
        print("Well that happened! " + rConnected.toString());
        serverDown = false;
      });
      final rPresenting = await BaseClientAPI().askInfo("/presenting");
      final rPresenter = await BaseClientAPI().askInfo("/presenter");
      final rLive = await BaseClientAPI().askInfo("/get_streaming_status");
      final rRecording = await BaseClientAPI().askInfo("/get_recording_status");
      final rCurrentScene = await BaseClientAPI().askInfo("/get_current_scene");
      final rApps = await BaseClientAPI().askInfo("/get_open_windows");
      final rScenes = await BaseClientAPI().askInfo("/get_scenes");
      setState(() {
        presenting = bool.parse(rPresenting["Data"]);
        presenter = bool.parse(rPresenter["Data"]);
        apps = rApps["Data"];
      });
      if (bool.parse(rConnected["Error"]) == true) {
        setState(() {
          connected = true;
          live = bool.parse(rLive["Data"]);
          recording = bool.parse(rRecording["Data"]);
          current_scene = rCurrentScene["Data"];
          scenes = rScenes["Data"];
        });
      } else {
        await BaseClientAPI().askInfo("/connect_to_obs");
        setState(() {
          connected = false;
        });
      }
    } else {
      setState(() {
        serverDown = true;
        connected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> allScenes = List<String>.from(scenes.whereType<String>());
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : !serverDown
              ? Center(
                  child: SingleChildScrollView(
                    // Wrap the Column in a scrollable view
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ServerBox(
                          apps: apps,
                          serverDown: serverDown,
                          presenting: presenting,
                          connected: connected,
                          presenter: presenter,
                        ),
                        ObsBox(
                          connected: connected,
                          serverDown: serverDown,
                          live: live,
                          recording: recording,
                          current_scene: current_scene,
                          scenes: allScenes,
                        ),
                        ControlBox(
                          connected: connected,
                          serverDown: serverDown,
                          live: live,
                          recording: recording,
                          current_scene: current_scene,
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
