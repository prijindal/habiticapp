import 'package:flutter/material.dart';

import '../../models/task.dart';

class TaskContainer extends StatelessWidget {
  TaskContainer({Key key, this.task}):super(key: key);
  
  final Task task;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        child: new ListTile(
          title: new Text(task.text)
        )
      );
    }
}
