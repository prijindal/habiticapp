// import 'dart:async';
import 'package:flutter/material.dart';

import 'home/task.dart';
import '../models/task.dart';

import '../helpers/theme.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({ Key key, this.task }): super(key: key);

  final Task task;

  @override
  _TaskScreenState createState() => new _TaskScreenState(task: task);
}

class _TaskScreenState extends State<TaskScreen> {
  _TaskScreenState({this.task}):super();

  Task task;
  // bool _first = true;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      // new Timer(new Duration(milliseconds: 100), toggleTitle);
    }
  
  // toggleTitle() {
  //   setState(() {
  //     _first = false;
  //   });
  // }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Edit ${task.type}")
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              title: new MarkDownTaskText(
                text: task.text,
                textStyle: mainTheme.textTheme.title.merge(new TextStyle(
                  fontSize: 20.0,
                ))
              )
            ),
          ],
        ),
      );
    }
}
