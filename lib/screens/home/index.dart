import 'package:flutter/material.dart'; 

import '../../sagas/tasks.dart';
import '../../components/drawer.dart';
import 'body.dart';

class Choice {
  const Choice({ this.title, this.icon,this.type });
  final String title;
  final IconData icon;
  final String type;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'HABITS', icon: Icons.directions_car, type: "habit"),
  const Choice(title: 'DAILIES', icon: Icons.directions_bike, type: "daily"),
  const Choice(title: 'TASKS', icon: Icons.directions_boat, type: "todo"),
  const Choice(title: 'REWARDS', icon: Icons.directions_bus, type: "reward"),
];

class HomePage extends StatefulWidget {
  HomePage({ Key key, this.onLoggedOut }): super(key: key);
  final void Function() onLoggedOut;
  @override
  HomePageState createState() => new HomePageState(onLoggedOut: onLoggedOut);
}

class HomePageState extends State<HomePage> {
  HomePageState({ this.onLoggedOut });  
  final String title = "Home Page";
  final void Function() onLoggedOut;
  
  @override
    void initState() {
      super.initState();
      getOfflineTasks();
      getNetworkTasks();
    }

  @override
    Widget build(BuildContext context) {
      return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          drawer: new MainDrawer(),
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
