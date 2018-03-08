import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/login.dart';
import '../api/login.class.dart';

import '../helpers/focusnode.dart';
import '../helpers/theme.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({ Key key, this.onLoggedIn }): super(key: key);

  @required
  final ValueChanged<LoginResponse> onLoggedIn;

  _onGenerateRoute(RouteSettings route) {
    if(route.name == "/") {
      return new MaterialPageRoute(
        builder: (context) => new LoginPage(onLoggedIn: onLoggedIn)
      );
    } else if(route.name == "/signup") {
      return new MaterialPageRoute(
        builder: (context) => new LoginPage(onLoggedIn: onLoggedIn)
      );
    } else {
      return null;
    }
  }
  
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new MaterialApp(
        theme: mainTheme,
        onGenerateRoute: _onGenerateRoute  
      );
    }
}

class LoginPage extends StatefulWidget {
  LoginPage({ Key key, this.onLoggedIn }): super(key: key);
  final String title = "Login Page";
  final ValueChanged<LoginResponse> onLoggedIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = new TextEditingController();
  final TextEditingController _passwordcontroller = new TextEditingController();

  String _error = "";
  bool isLoggingLoading = false;

  _loginHabitica() async {
    setState(() {
      isLoggingLoading = true;
    });
    try {
      LoginResponse data = await login(_emailcontroller.text, _passwordcontroller.text);
      if (!mounted) return;  
      // var result = data['id'];
      setState(() {
        _error = "";
        isLoggingLoading = false;
      });
      widget.onLoggedIn(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', data.id);
      prefs.setString('apiToken', data.apiToken);
    } catch(e) {
      print(e);
      setState(() {
        _error = e.toString();
        isLoggingLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 4.0,
        title: new Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Form(
              autovalidate: true,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,          
                children: <Widget>[
                  new ListTile(
                    title: new TextFormField(
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: new AutoDisabledFocusNode(
                        isEnabled: !isLoggingLoading
                      ),
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: "Username"
                      ),
                    ),
                  ),
                  new ListTile(
                    title: new TextFormField(
                      controller: _passwordcontroller,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      focusNode: new AutoDisabledFocusNode(
                        isEnabled: !isLoggingLoading
                      ),
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: "Password"
                      ),
                    ),
                  ),
                  new ListTile(
                    // padding: new EdgeInsets.only(left: 24.0, top: 24.0),
                    title: new RaisedButton(
                      onPressed: isLoggingLoading ? null : _loginHabitica,
                      child: new Text("Login"),
                    ),
                  ),
                  new ListTile(
                    // padding: new EdgeInsets.only(left: 24.0, top: 24.0),
                    title: new RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: new Text("Signup"),
                    ),
                  ),
                ],
              ),
            ),
            new Text(
              _error.isNotEmpty ? '$_error' : "",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}
