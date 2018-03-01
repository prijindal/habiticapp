import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Login Page";

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = new TextEditingController();
  final TextEditingController _passwordcontroller = new TextEditingController();

  String _error = "";

  _loginHabitica() async {
    var url = "https://habitica.com/api/v3/user/auth/local/login";
    var httpClient = new http.Client();
    String result;
    try {
      var request = new http.Request('POST', Uri.parse(url));
      var body = {'username':_emailcontroller.text, 'password':_passwordcontroller.text};
      request.bodyFields = body;
      var responseStream = await httpClient.send(request);
      var response = await responseStream.stream.bytesToString();
      var json = response.toString();
      var responseJson = JSON.decode(json);
      if (!mounted) return;
      if (responseStream.statusCode == HttpStatus.OK) {
        var data = responseJson['data'];              
        result = data['id'];
        setState(() {
          _error = "";
        });
        Navigator.of(context).pushNamed('/home');
        // var loginRoute = Navigator.of(context).widget.onGenerateRoute(
        //   new RouteSettings(name: Navigator.defaultRouteName),
        // );
        // var homeRoute = Navigator.of(context).widget.onGenerateRoute(
        //   new RouteSettings(name: '/home'),
        // );
        // Navigator.of(context).replace(oldRoute: loginRoute, newRoute: homeRoute);
      } else {
        setState(() {
          _error = responseJson['error'];
        });
      }
    } catch(Exception) {
      setState(() {
        _error = "Unexpected Error Occured";
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
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: "Password"
                      ),
                    ),
                  ),
                  new ListTile(
                    // padding: new EdgeInsets.only(left: 24.0, top: 24.0),
                    title: new RaisedButton(
                      onPressed: () {
                        _loginHabitica();
                      },
                      child: new Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
            new Text(
              _error.isEmpty ? '$_error' : null,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
