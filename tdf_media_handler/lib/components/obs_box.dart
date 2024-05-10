import "package:flutter/material.dart";
import "package:tdf_media_handler/components/client.dart";

class ObsBox extends StatefulWidget {
  final bool live;
  final bool recording;
  final String current_scene;
  final bool serverDown;
  final bool connected;
  final List<String> scenes;
  ObsBox({
    super.key,
    required this.live,
    required this.recording,
    required this.current_scene,
    required this.serverDown,
    required this.connected,
    required this.scenes,
  });

  @override
  State<ObsBox> createState() => _ObsBoxState();
}

class _ObsBoxState extends State<ObsBox> {
  @override
  Widget build(BuildContext context) {
    Future<String> sendData(api) async {
      BaseClientAPI clientAPI = BaseClientAPI();
      final response = await clientAPI.askInfo(api);
      return response["Data"].toString();
    }

    String dropDownValue = widget.current_scene;

    void changeScene() {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            // Wrap in StatefulBuilder
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      3.0), // Change this value to adjust radius
                ),
                backgroundColor: Colors.white,
                content: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Select a scene",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Container(
                          width: 200,
                          child: DropdownButton(
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            items: widget.scenes.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                // Use StatefulBuilder's setState
                                dropDownValue = newValue!;
                              });
                            },
                            value: dropDownValue,
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  widget.live ? Colors.red : Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () async {
                            final response = await sendData(
                                "/set_current_scene/" + dropDownValue);

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(response.toString() +
                                    " Note: Change is UI will take some time")));
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Done",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    String safeSubstring(String str, int maxLength) {
      if (str.length <= maxLength) {
        return str; // No need to truncate, return the whole string
      } else {
        return str.substring(0, maxLength); // Truncate to maxLength
      }
    }

    void stopStreaming() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    3.0), // Change this value to adjust radius
              ),
              backgroundColor: Colors.white,
              content: Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      Text(
                        "Are you Sure You Want To",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "Stop Streaming?",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    ]),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final response =
                                      await sendData("/stop_streaming");
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(response.toString() +
                                              "  NOTE: Update in UI will Take time")));
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: Text(
                                  "Confirm",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  child: Text(
                                    "Cancel",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    void stopRecording() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    3.0), // Change this value to adjust radius
              ),
              backgroundColor: Colors.white,
              content: Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      Text(
                        "Are you Sure You Want To",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "Stop Recording?",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    ]),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final response =
                                      await sendData("/stop_recording");
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(response.toString() +
                                              "  NOTE: Update in UI will Take time")));
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: Text(
                                  "Confirm",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  child: Text(
                                    "Cancel",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.connected
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          widget.connected
                              ? "Connected to the OBS"
                              : "Not Connected to the OBS",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "LiveStreaming:- ",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                                children: [
                                  TextSpan(
                                      text: widget.live ? "ON" : "OFF",
                                      style: TextStyle(
                                          color: widget.live
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: RichText(
                          text: TextSpan(
                            text: "Recording:- ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: [
                              TextSpan(
                                  text: widget.recording ? "YES" : "NO",
                                  style: TextStyle(
                                      color: widget.recording
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: RichText(
                          softWrap:
                              true, // Ensure soft wrapping within the maxWidth
                          overflow: TextOverflow
                              .visible, // Prevent clipping beyond maxWidth
                          maxLines: null, // No line limit for wrapping
                          text: TextSpan(
                            text: "Current Scene:- ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: [
                              TextSpan(
                                  text: safeSubstring(widget.current_scene, 15),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              if (widget.current_scene.length >=
                                  15) // Check if exceeds length
                                TextSpan(
                                  text: '...', // Add ellipsis
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 200.0),
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (widget.live) {
                              stopStreaming();
                            } else {
                              final response =
                                  "Streaming has not started. Starting the stream isn't available for now!";
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(response.toString() +
                                      "  NOTE: Update in UI will Take time")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  widget.live ? Colors.red : Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            widget.live ? "Stop Streaming" : "Not Streaming",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!widget.recording) {
                              final response =
                                  await sendData("/start_recording");
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "$response  NOTE: Update in UI will Take time")));
                            } else {
                              stopRecording();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  widget.recording ? Colors.red : Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            widget.recording
                                ? "Stop Recording"
                                : "Start Recording",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            changeScene();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            "Change Scene",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            widget.connected
                                ? "Connected to the OBS"
                                : "Not Connected to the OBS",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ]),
          ],
        ));
  }
}
