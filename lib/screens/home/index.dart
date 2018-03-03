import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'taskinput.dart';
import 'task.dart';

import '../../api/tasks.dart';
import '../../api/login.class.dart';
import '../../models/task.dart';
import '../../helpers/savedlogin.dart';

class HomePage extends StatelessWidget {
  HomePage({ Key key, this.onLoggedOut }): super(key: key);  
  final String title = "Home Page";
  final void Function() onLoggedOut;  

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          elevation: 4.0,
          title: new Text(this.title),
          actions: <Widget>[
            new IconButton(
              onPressed: onLoggedOut,
              icon: new Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: new Container(
          child: new HomePageBody()
        )
      );
    }
}

class HomePageBody extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePageBody> {
  bool _enableAddTask = false;
  bool _isTasksLoading = true;
  static const String type = "habits";
  List<TaskContainer> _tasks = <TaskContainer>[];

  @override
  initState() {
    super.initState();
    _getOfflineTasks();    
    _getTasks();
  }

  _getOfflineTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove(type);
      List<String> tasks = prefs.getStringList(type);
      if(tasks == null) {
        return;
      }
      List<TaskContainer> taskContainers = tasks.map((task) => new TaskContainer(task: new Task(JSON.decode(task)))).toList();
      if(_isTasksLoading) {
        setState(() {
          _tasks = taskContainers;
        });
      }
    } catch(e) {
      print(e);
    }
  }

  _getTasks() async {
    try {
      setState(() {
        _isTasksLoading = true;
      });
      LoginResponse loginInformation = await getLoginInformation();
      List<Task> data = await getTasks(type: type, loginInformation: loginInformation);
      List<TaskContainer> taskContainers = data.map((Task task) => new TaskContainer(task: task)).toList();
      setState(() {
        _tasks = taskContainers;
        _isTasksLoading = false;
      });
      _syncTasks();
    } catch(e) {
      print(e);
    }
  }

  _syncTasks() async {
    // TODO: Switch to sqlite
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(type, _tasks.map((taskContainer) => JSON.encode(taskContainer.task.toMapped())).toList());
  }

  _onNewTask(String text) {
    TaskContainer taskContainer = new TaskContainer(
      task: new Task({'text': 'text'}),
    );
    setState(() {
      _tasks.add(taskContainer);
    });
  }

  @override
    Widget build(BuildContext context) {
      return new Stack(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Flexible(
                child: new RefreshIndicator(
                  onRefresh: _getTasks,
                  child: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    itemBuilder: (_, int index) => _tasks[index],
                    itemCount: _tasks.length,
                  ),
                )
              ),
              new Container(
                child: (
                  _enableAddTask ?
                  new AddTaskInput(
                    onBackButton:() {
                      setState(() {
                        _enableAddTask = false;
                      });
                    },
                    onSubmit: _onNewTask
                  ) :
                  null
                )
              )
            ]
          ),
          new Container(
            child: (_enableAddTask ?
              null :
              new AddTaskFloating(
                onPressed: () {
                  setState(() {
                    _enableAddTask = true;
                  });
                }
              )
            )
          )
        ],
      );
    }
}

class AddTaskFloating extends StatelessWidget {
  AddTaskFloating({Key key, this.onPressed}): super(key: key);

  final void Function() onPressed;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Positioned(
        bottom: 16.0,
        right: 16.0,
        child: new Container(
          child: new FloatingActionButton(
            onPressed: onPressed,
            child: const Icon(Icons.add),
          ),
        ),
      );
    }
}
