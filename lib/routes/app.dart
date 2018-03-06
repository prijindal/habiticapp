import 'package:flutter/material.dart';
import '../screens/home/index.dart';

import '../helpers/theme.dart';
import '../observers/route.dart';

class App extends StatelessWidget {
  App({ Key key, this.onLoggedOut }): super(key: key);

  final void Function() onLoggedOut;

    Widget build(BuildContext context) {
      return new MaterialApp(
        title: 'Habitica Client',
        theme: mainTheme,
        navigatorObservers: [routeObserver],
        routes: <String, WidgetBuilder> {
          '/': (BuildContext context) => new HomePage(
            onLoggedOut: onLoggedOut,
          ),
          '/guilds': (BuildContext context) => new HomePage(
            onLoggedOut: onLoggedOut,
          )
        },
      );
    }
}
