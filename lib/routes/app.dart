import 'dart:collection';
import 'package:flutter/material.dart';
import '../screens/home/index.dart';
import '../screens/task/index.dart';

import '../helpers/theme.dart';
import '../observers/route.dart';
import '../models/task.dart';

GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  App({ Key key, this.onLoggedOut }): super(key: key);

  final void Function() onLoggedOut;

  Route<dynamic> _onGenerateRoute(RouteSettings route) {
    var routeSplitted = route.name.split('/');
    print(routeSplitted);
    if(routeSplitted.length > 2) {
      // Eg: /tasks/54a81d23-529c-4daa-a6f7-c5c6e7e84936
      if(routeSplitted[1] == 'tasks') {
        return new MaterialPageRoute<Null>(
          builder: (BuildContext context) => 
            new TaskScreen(
              task: new Task(LinkedHashMap.from({
                "id": routeSplitted[2]
              }))
            ),
          fullscreenDialog: true
        );
      }
      return null;
    }
    return null;
  }

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
        onGenerateRoute: _onGenerateRoute
      );
    }
}
