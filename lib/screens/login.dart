import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/login.dart';
import '../api/login.class.dart';

import '../helpers/focusnode.dart';

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
      print(e.toString());
      setState(() {
        _error = e.toString();
        isLoggingLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the LoginPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Container(
        // padding: const EdgeInsets.all(8.0),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
                      initialValue: "priyanshujindal1995@gmail.com",
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
                      initialValue: "Priyanshu@95",
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
                ],
              ),
            ),
            new Text(
              _error.isNotEmpty ? '$_error' : "",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
