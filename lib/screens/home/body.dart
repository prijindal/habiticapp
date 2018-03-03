import 'package:flutter/material.dart';

import 'taskinput.dart';
import 'task.dart';

import '../../api/tasks.dart';
import '../../api/login.class.dart';
import '../../models/task.dart';
import '../../helpers/savedlogin.dart';

class HomePageBody extends StatefulWidget {
  HomePageBody({Key key, this.type="habits"}):super(key:key);
  final String type;
  @override
  _HomePageState createState() => new _HomePageState(type: type);
}

class _HomePageState extends State<HomePageBody> {
  _HomePageState({this.type}):super() {
    _taskProvider = new TaskProvider(tableTask: type);
  }

  final String type;
  
  bool _enableAddTask = false;
  bool _isTasksLoading = true;
  List<TaskContainer> _tasks = <TaskContainer>[];
  TaskProvider _taskProvider;

  @override
  initState() {
    super.initState();
    _getOfflineTasks();    
    _getTasks();
  }

  _getOfflineTasks() async {
    try {
      await _taskProvider.open();
      List<Task> tasks = await _taskProvider.getTasks();
      if(tasks == null) {
        return;
      }
      List<TaskContainer> taskContainers = tasks.map((Task task) => new TaskContainer(task: task)).toList();      
      if(taskContainers == null) {
        return;
      }
      if(_isTasksLoading && mounted) {
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
      if(data == null) {
        return;
      }
      List<TaskContainer> taskContainers = data.map((Task task) => new TaskContainer(task: task)).toList();
      if(taskContainers == null) {
        return;
      }
      if(!mounted) return;
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
    try {
      await _taskProvider.sync(_tasks.map((taskContainer) => taskContainer.task).toList());
    } catch(e) {
      print(e);
    }
  }

  _onNewTask(String text) {
    TaskContainer taskContainer = new TaskContainer(
      task: new Task({'text': text}),
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
                    padding: new EdgeInsets.all(0.0),
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
