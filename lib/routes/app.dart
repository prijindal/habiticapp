import 'package:flutter/material.dart';
import '../screens/home/index.dart';

import '../helpers/theme.dart';

class App extends StatelessWidget {
  App({ Key key, this.onLoggedOut }): super(key: key);

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
