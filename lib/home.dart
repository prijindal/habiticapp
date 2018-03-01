import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String title = "Home Page";

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.title),
        ),
        body: new Container(
          child:new Center(
            child: new Text("Hello World"),
          )
        )
      );
    }
}
