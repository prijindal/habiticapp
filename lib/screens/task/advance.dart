import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import '../../models/task.dart';
import 'subhead.dart';

class TaskScreenAdvance extends StatelessWidget {
  TaskScreenAdvance({ Key key, this.task, this.onChanged }): super(key: key);

  @required
  final Task task;

  @required
  final Function(Task task) onChanged;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      if(task.type == "habit") {
        return new HabitScreenAdvance(
          task: task,
          onChanged: onChanged
        );
      } else if(task.type == "daily") {
        return new DailyScreenAdvance(
          task: task,
          onChanged: onChanged
        );
      } else if(task.type == "todo") {
        return new TodoScreenAdvance(
          task: task,
          onChanged: onChanged
        );
      } else {
        return new Text("Some Error Occured");
      }
    }
}

class HabitScreenAdvance extends StatelessWidget { 
  HabitScreenAdvance({ Key key, this.task,this.onChanged }): super(key: key);

  @required
  final Task task;

  @required
  final void Function(Task task) onChanged;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
        children: <Widget>[
          new SubHead("Actions"),
          new CheckboxListTile(
            onChanged: (bool newValue) {
              task.up = !task.up;
              onChanged(task);
            },
            value: task.up,
            title: new Text("Positive"),
          ),
          new CheckboxListTile(
            onChanged: (bool newValue) {
              task.down = !task.down;
              onChanged(task);
            },
            value: task.down,
            title: new Text("Negative"),
          )
        ],
      );
    }
}

class DailyScreenAdvance extends StatelessWidget {
  DailyScreenAdvance({ Key key, this.task,this.onChanged }): super(key: key);

  @required
  final Task task;

  @required
  final void Function(Task task) onChanged;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
        children: <Widget>[
          new CheckListInput(
            task: task,
            onChanged: onChanged,
          ),
        ],
      );
    }
}

class TodoScreenAdvance extends StatelessWidget {
  TodoScreenAdvance({ Key key, this.task,this.onChanged }): super(key: key);

  @required
  final Task task;

  @required
  final void Function(Task task) onChanged;


  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
        children: <Widget>[
          new CheckListInput(
            task: task,
            onChanged: onChanged,
          ),
        ],
      );
    }
}

class CheckListInput extends StatelessWidget {
  CheckListInput({ Key key, this.task,this.onChanged }): super(key: key);

  @required
  final Task task;

  @required
  final void Function(Task task) onChanged;

  final TextEditingController _checkListInputController = new TextEditingController();

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
        children: <Widget>[
          new SubHead('CheckList'),
          new Column(
            children: task.checklist.map((item) =>
              new CheckboxListTile(
                onChanged: (bool newValue) {
                  task.checklist[task.checklist.indexOf(item)].completed = newValue;
                  onChanged(task);
                },
                value: item.completed,
                title: new Text(item.text)
              )
            ).toList()
          ),
          new ListTile(
            title: new TextFormField(
              controller: _checkListInputController,
              decoration: new InputDecoration(
                hintText: "New Check List Item"
              ),
              onFieldSubmitted: (String text) {
                task.checklist.add(new TaskCheckListItem({"text": text, "id": text}));
                onChanged(task);
                _checkListInputController.clear();
              },
            )
          ),          
        ],
      );
    }
}
