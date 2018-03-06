import 'package:flutter/material.dart';

import 'home/task.dart';
import '../models/task.dart';
import '../helpers/markdown.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({ Key key, this.task }): super(key: key);

  final Task task;

  @override
  _TaskScreenState createState() => new _TaskScreenState(task: task);
}

class _TaskScreenState extends State<TaskScreen> {
  _TaskScreenState({this.task}):super();

  Task task;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(convertEmojis(task.text)),
        ),
        body: new TaskContainer(
          task: task,
        ),
      );
    }
}
