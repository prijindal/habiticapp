import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:simple_moment/simple_moment.dart';

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
          new ReminderInput(
            task: task,
            onChanged: onChanged,
          )
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
          new ReminderInput(
            task: task,
            onChanged: onChanged,
          )
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
                secondary: new IconButton(
                  onPressed: () {
                    task.checklist.remove(item);
                    onChanged(task);
                  },
                  icon: new Icon(Icons.close),
                ),
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

class ReminderInput extends StatelessWidget {
  ReminderInput({ Key key, this.task,this.onChanged }): super(key: key);

  @required
  final Task task;

  @required
  final void Function(Task task) onChanged;

  _addDate(BuildContext context) async {
    var date = await showDatePicker(
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2016),
      context: context,
      lastDate: new DateTime(2020)
    );
    var time = await showTimePicker(
      initialTime: new TimeOfDay.fromDateTime(date),
      context: context
    );
    date = new DateTime(date.year, date.month, date.day, time.hour, time.minute);
    TaskReminder newReminder = new TaskReminder({
      "time": date.toIso8601String(),
    });
    task.reminders.add(newReminder);
    onChanged(task);
  }

  String _getDateString(String time) {
    return new Moment.fromDate(new DateTime.now()).from(DateTime.parse(time));
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
        children: <Widget>[
          new SubHead('Reminders'),
          new Column(
            children: task.reminders.map((item) =>
              new ListTile(
                leading: new IconButton(
                  onPressed: () {
                    task.reminders.remove(item);
                    onChanged(task);
                  },
                  icon: new Icon(Icons.close),
                ),
                title: new Text(_getDateString(item.time)),
              )
            ).toList()
          ),
          new ListTile(
            leading: new IconButton(
              onPressed: () => _addDate(context),
              icon: new Icon(Icons.add),
            ),
            title: new Text("Add New Date")
          ),          
        ],
      );
    }
}
