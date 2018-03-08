import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart'; 

import '../../sagas/tasks.dart';
import '../../components/drawer.dart';
// import 'body.dart';

import 'taskinput.dart';
import 'task.dart';

import '../../models/task.dart';

import '../../store.dart';

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


enum PopupActions { refresh, exit }

class HomePage extends StatefulWidget {
  HomePage({ Key key, this.onLoggedOut }): super(key: key);
  final void Function() onLoggedOut;
  @override
  HomePageState createState() => new HomePageState(onLoggedOut: onLoggedOut);
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  HomePageState({ this.onLoggedOut });  
  final String title = "Home Page";
  final void Function() onLoggedOut;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  
  bool _enableAddTask = false;
  List<Task> tasks;
  bool isLoading = false;
  TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: choices.length);
    tasks = tasksstore.state.tasks;
    isLoading = tasksstore.state.isLoading;
    tasksstore.onChange.listen((state) {
      if(mounted) {
        setState(() {
          tasks = state.tasks;
          isLoading = state.isLoading;
        });
      }
    });
    getOfflineTasks();
    getNetworkTasks();
    // new Timer(new Duration(), () => _refreshIndicatorKey.currentState.show());
  }

  void _handlePopupActions(PopupActions action) {
    switch (action) {
      case PopupActions.refresh:
        _refreshIndicatorKey.currentState.show();
        break;
      case PopupActions.exit:
        onLoggedOut();
        break;
      default:
    }
  }

  List<Task> getTasks(String type) {
    if(tasks == null) {
      return [];
    }
    return tasks.where((task) => task.type == type).toList();
  }

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        drawer: new MainDrawer(),
        floatingActionButton: (
          !_enableAddTask ?
          new FloatingActionButton(
            onPressed: () {
              setState(() {
                _enableAddTask = true;
              });
            },
            child: new Icon(Icons.add),
          ): null
        ),
        body: new Stack(
          children: <Widget>[
            new NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    // floating: true,
                    // snap: true,
                    pinned: true,
                    elevation: 4.0,
                    expandedHeight: 128.0,
                    title: new Text("Habitica"),
                    flexibleSpace: new FlexibleSpaceBar(
                      background: new Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new TabBar(
                            controller: _tabController,
                            tabs: choices.map((Choice choice) {
                              return new Tab(
                                text: choice.title,
                                icon: new Icon(choice.icon),
                              );
                            }).toList(),
                          ),
                        ]
                      ),
                    ),
                    actions: <Widget>[
                      new PopupMenuButton<PopupActions>(
                        onSelected: _handlePopupActions,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupActions>>[
                          new PopupMenuItem(
                            enabled: !isLoading,
                            value: PopupActions.refresh,
                            child: new Text("Refresh"),
                          ),
                          new PopupMenuItem(
                            value: PopupActions.exit,
                            child: new Text("Logout"),
                          ),
                        ]
                      ),
                    ],
                  ),
                ];
              },
              body: new RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () => getNetworkTasks(),
                child: new TabBarView(
                  controller: _tabController,
                  children: choices.map((Choice choice) =>
                    new HomePageBody(
                      tasks: getTasks(choice.type),
                      key: new Key(choice.type)
                    )
                  ).toList(),
                ),
              ),
            ),
            (
            _enableAddTask ?
              new Positioned(
                bottom: 0.0,
                left: 0.0,
                child: new Container(
                  color: new Color(0xFFFFFFFF),
                  width: MediaQuery.of(context).size.width,
                  height: 48.0,
                  child: new AddTaskInput(
                    type:choices[_tabController.index].type,
                    onBackButton:() {
                      setState(() {
                        _enableAddTask = false;
                      });
                    },
                  ),
                )
              ): new Container()
            )
          ],
        ),
      );
    }
}

class HomePageBody extends StatelessWidget {
  HomePageBody({Key key, this.tasks}):super(key:key);
  
  @required
  final List<Task> tasks;

  @override
    Widget build(BuildContext context) {
      return new RefreshIndicator(
        onRefresh: () => getNetworkTasks(),
        child: new ListView.builder(
          shrinkWrap: true,
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (_, int index) => new TaskContainer(
            task: tasks[index],
            key: new Key(tasks[index].id),
          ),
          itemCount: tasks.length,
        )
      );
    }
}
