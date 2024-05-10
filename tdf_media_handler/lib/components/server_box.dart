import "package:flutter/material.dart";

class ServerBox extends StatelessWidget {
  final bool presenting;
  final bool connected;
  final bool presenter;
  final bool serverDown;
  final List apps;
  const ServerBox({
    super.key,
    required this.presenting,
    required this.connected,
    required this.presenter,
    required this.serverDown,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
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
                        for (final app in apps)
                          ListTile(
                            title: Text(
                              app.toString(),
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

    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !serverDown
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          serverDown
                              ? "Server Is Down"
                              : "Connected to the server",
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
                                  text: presenting ? "ON" : "OFF",
                                  style: TextStyle(
                                      color: presenting
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
                                  text: connected ? "YES" : "NO",
                                  style: TextStyle(
                                      color:
                                          connected ? Colors.green : Colors.red,
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
                                  text: presenter ? "YES" : "NO",
                                  style: TextStyle(
                                      color:
                                          presenter ? Colors.green : Colors.red,
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
                          serverDown
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
