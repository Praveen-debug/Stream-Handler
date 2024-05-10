import 'package:flutter/material.dart';
import 'package:tdf_media_handler/pages/status_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            title: const Text("Home"),
            centerTitle: true,
            titleTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            backgroundColor: Colors.black87,
          ),
          body: StatusPage(),
        ));
  }
}
