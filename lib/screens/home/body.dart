import 'package:flutter/material.dart';


import 'taskinput.dart';
import 'task.dart';

import '../../models/task.dart';

import '../../sagas/tasks.dart';
import '../../store.dart';

class HomePageBody extends StatefulWidget {
  HomePageBody({Key key, this.type}):super(key:key);
  final String type;
  @override
  _HomePageState createState() => new _HomePageState(type: type);
}

class _HomePageState extends State<HomePageBody> {
  _HomePageState({this.type}):super();

  final String type;
  
  bool _enableAddTask = false;
  List<Task> tasks;
  bool isLoading = store.state.isLoading;

  @override
  initState() {
    tasks = reduceTasks(store.state.tasks);
    super.initState();
    store.onChange.listen((state) {
      if(mounted) {
        setState(() {
          tasks = reduceTasks(state.tasks);
          isLoading = state.isLoading;
        });
      }
    });
  }

  List<Task> reduceTasks(List<Task> allTasks) {
    if(allTasks == null) {return [];}
    return allTasks.where((task) => task.type == type).toList();
  }

  @override
    Widget build(BuildContext context) {
      return new Stack(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Container(
                height: 4.0,
                child: (
                  isLoading ?
                  new LinearProgressIndicator(
                    value: null,
                  ) : null
                )
              ),
              new Flexible(
                child: new RefreshIndicator(
                  onRefresh: () => getNetworkTasks(),
                  child: (
                    (tasks != null && tasks.length > 0) ?
                    new ListView.builder(
                      padding: new EdgeInsets.all(0.0),
                      itemBuilder: (_, int index) => new TaskContainer(
                        task: tasks[index],
                        key: new Key(tasks[index].id),
                      ),
                      itemCount: tasks.length,
                    ):
                    new ListView(
                      children: <Widget> [
                        new ConstrainedBox(
                          constraints: new BoxConstraints(
                            minHeight: 64.0
                          ),
                          child: new Center(
                            child: (
                              isLoading ?
                              new Text("Please Wait..."):
                              new Text("No data here")
                            )
                          )
                        ),
                      ]
                    )
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
                    onSubmit: (task) => onNewTask(task, type)
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
