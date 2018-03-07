import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/loading.dart';
import '../screens/login.dart';

import 'app.dart';

import '../api/login.class.dart';

import '../sagas/user.dart';
import '../sagas/tasks.dart';

class RootApplication extends StatefulWidget {
  RootApplication({this.initialScreen, Key key}):super(key: key);
  // This widget is the root of your application.
  
  final StatefulWidget initialScreen;
  @override
  _RootHandlerState createState() => new _RootHandlerState();
}

class _RootHandlerState extends State<RootApplication> {
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
        getOfflineUser();
        getNetworkUser();
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
    getNetworkUser();
  }

  _onLoggedOut() {
    setState(() {
      _isLoggedIn = false;
    });
    _prefs.clear();
    clearUser();
    clearTasks();
  }

  _buildApp() {
    if (widget.initialScreen != null) {
      return widget.initialScreen;
    }
    return new App(
      onLoggedOut: _onLoggedOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: (
        _isLoading ?
        new LoadingScreen() :
        new Container(
          child: (_isLoggedIn
                ? _buildApp()
                : new LoginScreen(
                  onLoggedIn: _onLoggedIn
                )),
        )
      )
    );
  }
}
