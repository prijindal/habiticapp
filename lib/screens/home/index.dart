import 'package:flutter/material.dart';

import 'body.dart';

class Choice {
  const Choice({ this.title, this.icon,this.type });
  final String title;
  final IconData icon;
  final String type;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'HABITS', icon: Icons.directions_car, type: "habits"),
  const Choice(title: 'DAILIES', icon: Icons.directions_bike, type: "dailys"),
  const Choice(title: 'TASKS', icon: Icons.directions_boat, type: "todos"),
  const Choice(title: 'REWARDS', icon: Icons.directions_bus, type: "rewards"),
];

class HomePage extends StatelessWidget {
  HomePage({ Key key, this.onLoggedOut }): super(key: key);  
  final String title = "Home Page";
  final void Function() onLoggedOut;  

  @override
    Widget build(BuildContext context) {
      return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            elevation: 4.0,
            title: new Text("Habitica"),
            bottom: new TabBar(
              // isScrollable: true,
              tabs: choices.map((Choice choice) {
                return new Tab(
                  text: choice.title,
                  icon: new Icon(choice.icon),
                );
              }).toList(),
            ),
            actions: <Widget>[
              new IconButton(
                onPressed: onLoggedOut,
                icon: new Icon(Icons.exit_to_app),
              )
            ],
          ),
          body: new TabBarView(
            children: choices.map((Choice choice) {
              return new Container(
                // padding: const EdgeInsets.all(16.0),
                child: new HomePageBody(type: choice.type),
              );
            }).toList(),
          ),
        ),
      );
    }
}
