import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';

class MyAppHandler extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppHandlerState createState() => new _MyAppHandlerState();
}

class _MyAppHandlerState extends State<MyAppHandler> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: (_isLoggedIn
            ? new HomePage()
            : new LoginPage(
              onLoggedIn: (isLoggedIn) {
                setState(() {
                  _isLoggedIn = isLoggedIn;
                });
              }
            )),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Habitica Client',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyAppHandler(),
    );
  }
}
