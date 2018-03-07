// import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'home/task.dart';
import '../models/task.dart';

import '../helpers/theme.dart';
import '../helpers/savedlogin.dart';
import '../api/tasks.dart';


class TaskScreen extends StatefulWidget {
  TaskScreen({ Key key, this.task }): super(key: key);

  @required
  final Task task;

  @override
  _TaskScreenState createState() => new _TaskScreenState(task: task);
}

class _TaskScreenState extends State<TaskScreen> {
  _TaskScreenState({this.task}):super();

  @required
  Task task;

  @override
    void initState() {
      super.initState();
      getNetworkTask();
    }

  getNetworkTask() async {
    try {
      var loginInformation = await getLoginInformation();
      Task newTask = await getTask(task.id, loginInformation);
      setState(() {
        task = newTask;
      });
    } catch(e) {
      print(e);
    }
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new AnimatedCrossFade(
        duration: const Duration(seconds: 1),
        firstChild: new Text("Loading"),
        secondChild: new Scaffold(
          appBar: new AppBar(
            title: new Text("Edit ${(task.type != null ? task.type: "task")}")
          ),
          body: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new ListTile(
                title: new MarkDownTaskText(
                  text: (task.text != null ? task.text: ""),
                  textStyle: mainTheme.textTheme.body1
                )
              ),
            ],
          ),
        ),
        crossFadeState: (task == null) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      );
    }
}
