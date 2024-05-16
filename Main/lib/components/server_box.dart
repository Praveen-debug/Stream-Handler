import "package:flutter/material.dart";

class ServerBox extends StatelessWidget {
  final Map<String, dynamic>? data;
  final bool isConnected;
  const ServerBox({
    super.key,
    required this.data,
    required this.isConnected,
  });
  @override
  Widget build(BuildContext context) {
    List<String> windows = [];
    if (isConnected && data != null) {
      String windowsList = data?["windows"];
      windows = windowsList.split(r"', '");
    }
    void showApps() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  3.0), // Change this value to adjust radius
            ),
            backgroundColor: Colors.white,
            content: SizedBox(
              height: 300, // Set a specific height for the dialog
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Open Apps",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final app in windows)
                          ListTile(
                            title: Text(
                              app.toString().replaceAll("'", ""),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    print("Is connected is $isConnected");
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isConnected
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          isConnected
                              ? "Connected to the server"
                              : "Server is Down",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: RichText(
                          text: TextSpan(
                            text: "Presenting:- ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: [
                              TextSpan(
                                  text: data?["presenting"] == "true"
                                      ? "ON"
                                      : "OFF",
                                  style: TextStyle(
                                      color: data?["presenting"] == "true"
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
                          text: TextSpan(
                            text: "Connected to OBS:- ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: [
                              TextSpan(
                                  text: data?["obs"] == "true" ? "YES" : "NO",
                                  style: TextStyle(
                                      color: data?["obs"] == "true"
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
                          text: TextSpan(
                            text: "Presenter On:- ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            children: [
                              TextSpan(
                                  text: data?["presenter"] == "true"
                                      ? "YES"
                                      : "NO",
                                  style: TextStyle(
                                      color: data?["presenter"] == "true"
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: RichText(
                              text: const TextSpan(
                                text: "Open Apps:- ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: showApps,
                                child: const Text(
                                  "Click here",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          isConnected
                              ? "Server Is Down"
                              : "Connected to the server",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
