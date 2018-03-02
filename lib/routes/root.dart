import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login.dart';
import '../screens/home.dart';

import '../api/login.class.dart';

class RootHandler extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _RootHandlerState createState() => new _RootHandlerState();
}

class _RootHandlerState extends State<RootHandler> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  SharedPreferences _prefs;

  @override
    void initState() {
      super.initState();
      this.checkAuthorized();
    }

  checkAuthorized() async {
    _prefs = await SharedPreferences.getInstance();    
    try {
      String userid = _prefs.getString('id');      
      if(userid.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _isLoggedIn = true;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isLoggedIn = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
      });
    }
  }

  _onLoggedIn(LoginResponse data) {
    setState(() {
      _isLoggedIn = true;
    });
    _prefs.setString('id', data.id);
    _prefs.setString('apiToken', data.apiToken);
  }

  _onLoggedOut() {
    setState(() {
      _isLoggedIn = false;
    });
    _prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: (
        _isLoading ?
        new Text("Loading") :
        new Container(
          child: (_isLoggedIn
                ? new HomePage(
                  onLoggedOut: _onLoggedOut,
                )
                : new LoginPage(
                  onLoggedIn: _onLoggedIn
                )),
        )
      )
    );
  }
}

class RootApplication extends StatelessWidget {
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
      home: new RootHandler(),
    );
  }
}
