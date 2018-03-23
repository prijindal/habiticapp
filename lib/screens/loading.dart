import 'package:flutter/material.dart';
import '../helpers/theme.dart';

class LoadingScreen extends StatelessWidget {
  MaterialPageRoute _onGenerateRoute(RouteSettings route) {
    if(route.name == "/") {
      return new MaterialPageRoute(
        builder: (context) => new Scaffold(
          appBar: new AppBar(
            elevation: 4.0,
            title: new Text("Habitica App"),
          ),
        )
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
