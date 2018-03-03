import 'package:flutter/material.dart';
import '../screens/home/index.dart';

import '../helpers/theme.dart';

class User {
  String id;
  String apiToken;

  User({this.id, this.apiToken});
}

class App extends StatelessWidget {
  App({ Key key, this.user, this.onLoggedOut }): super(key: key);

  final User user;
  final void Function() onLoggedOut;

    Widget build(BuildContext context) {
      return new MaterialApp(
        title: 'Habitica Client',
        theme: mainTheme,
        routes: <String, WidgetBuilder> {
          '/': (BuildContext context) => new HomePage(
            onLoggedOut: onLoggedOut,
          )
        },
      );
    }
}
