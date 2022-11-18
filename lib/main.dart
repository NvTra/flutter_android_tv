import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'src/ui/home.dart';
import 'src/ui/recentfocustraversal.dart';
import 'src/ui/helper/inputhandler.dart';

void main() {
  if (kIsWeb) InputHandler.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _focusNode = RecentFocusNode(group: FocusGroup.root);

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          body: Focus(
            focusNode: _focusNode,
            descendantsAreFocusable: true,
            child: const Home(),
          ),
        ),
      ),
    );
  }
}

Future<bool> _willPopCallback() async {
  return false;
}
