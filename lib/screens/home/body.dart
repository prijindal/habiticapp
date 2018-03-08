import 'package:meta/meta.dart';
import 'package:flutter/material.dart'; 

import '../../sagas/tasks.dart';
import '../../models/task.dart';

import 'task.dart';

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
