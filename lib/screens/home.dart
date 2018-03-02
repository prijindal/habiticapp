import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({ Key key, this.onLoggedOut }): super(key: key);  
  final String title = "Home Page";
  final Function onLoggedOut;  

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.title),
          actions: <Widget>[
            new IconButton(
              onPressed: onLoggedOut,
              icon: new Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: new Container(
          child:new Center(
            child: new Text("Hello World"),
          )
        )
      );
    }
}
