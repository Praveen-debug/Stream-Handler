import "package:flutter/material.dart";
import "package:tdf_media_handler/components/client.dart";

class ControlBox extends StatelessWidget {
  final bool live;
  final bool recording;
  final String current_scene;
  final bool serverDown;
  final bool connected;
  ControlBox({
    super.key,
    required this.live,
    required this.recording,
    required this.current_scene,
    required this.serverDown,
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    Future<String> sendData(api) async {
      final response = await BaseClientAPI().askInfo(api);
      return response["Data"].toString();
    }

    void sendPopUpMessage() {
      showDialog(
          context: context,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    3.0), // Change this value to adjust radius
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Type Your Message",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.all(25),
                          child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Message here",
                                hintStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .black), // Set focused outline color
                                ),
                              ),
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              final response = await sendData(
                                  "/send_pop_up_notification?message=" +
                                      controller.text);
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response.toString())));
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text(
                              "Send",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          });
    }

    void sendNotification() {
      showDialog(
          context: context,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    3.0), // Change this value to adjust radius
              ),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Type Your Message",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.all(25),
                          child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Message here",
                                hintStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .black), // Set focused outline color
                                ),
                              ),
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              final response = await sendData(
                                  "/send_notification?message=" +
                                      controller.text);
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response.toString())));
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text(
                              "Send",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )),
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
            !serverDown
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          "Server Controls",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                            final response =
                                await sendData("/remove_presenter_screen");
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.toString())),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            "Remove Presenter Screen",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                            final response =
                                await sendData("/remove_verse_view_screen");
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response)));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            "Remove Verse View Screen",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: sendPopUpMessage,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: const Text(
                            "Send Pop Up Message",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: sendNotification,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: const Text(
                            "Send Notification",
                            style: TextStyle(color: Colors.white),
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
                            connected
                                ? "Connected to the OBS"
                                : "Not Connected to the OBS",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Colors.black),
                          ),
                        ),
                      ]),
          ],
        ));
  }
}
