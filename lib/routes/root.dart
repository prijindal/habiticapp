import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../screens/loading.dart';
import '../screens/login.dart';

import 'app.dart';

import '../api/login.class.dart';

import '../helpers/theme.dart';
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
      // new Timer(const Duration(seconds: 5), this.checkAuthorized);
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
        new LoadingScreen() :
        new Container(
          child: (_isLoggedIn
                ? new App(
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
      theme: mainTheme,
      home: new RootHandler(),
    );
  }
}
