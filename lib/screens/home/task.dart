import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';

import '../../models/task.dart';
import '../../libraries/markdown/flutter_markdown.dart';
import '../../helpers/markdown.dart';


import '../../helpers/theme.dart';

import '../task.dart';

class TaskContainer extends StatefulWidget {
  TaskContainer({Key key, this.task}):super(key: key);
  final Task task;

  @override
  _TaskContainerState createState() => new _TaskContainerState(task: task);
}

class _TaskContainerState extends State<TaskContainer> {
  _TaskContainerState({this.task}):super();

  Task task;
  bool _isSelected = false;

  _toggleSelected() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  _openTaskPage(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) => new TaskScreen(task: task),
      )
    );
  }

  _plusOneTask() {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Hello")));
  }

  _minusOneTask() {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Hello")));
  }

  _onTodoToggled(bool newValue) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(newValue.toString())));    
  }

  _onDailyDone(bool newValue) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Done")));        
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        color: (
          _isSelected ?
          Colors.black26:
          null
        ),
        child: new ListTile(
          enabled: true,
          onTap: (
            _isSelected ?
            _toggleSelected :
            () => _openTaskPage(context)
          ),
          onLongPress: _toggleSelected,
          selected: _isSelected,
          title: _buildTaskComponent(),
        )
      );
    }

  _buildTaskComponent() {
    switch (task.type) {
      case "todo":
        return new TodoTask(
          task: task,
          onTodoToggled: _onTodoToggled,
        );
        break;
      case "habit":
        return new HabitTask(
          task: task,
          plusOneTask: _plusOneTask,
          minusOneTask: _minusOneTask,
        );
        break;
      case "daily":
        return new DailyTask(
          task: task,
          onDailyDone: _onDailyDone
        );
      default:
        return new Text(task.text);
    }
  }
}

class DailyTask extends StatelessWidget {
  DailyTask({
    Key key,
    this.task,
    this.onDailyDone
  }):super(key:key);

  final Task task;
  final void Function(bool) onDailyDone;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Row(
        children: <Widget>[
          new Checkbox(
            value: task.completed,
            onChanged: onDailyDone,
          ),
          new Flexible(
            child: new TaskText(
              task: task,
              bottomWidget: new BottomRowDailys(
                task: task,
              ),
            ),
          )
        ],
      );
    }
}

class TodoTask extends StatelessWidget {
  TodoTask({
    Key key,
    this.task,
    this.onTodoToggled
  }):super(key:key);

  final Task task;
  final void Function(dynamic) onTodoToggled;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Row(
        children: <Widget>[
          new Radio(
            groupValue: task.completed,
            value: true,
            onChanged: onTodoToggled,
          ),
          new Flexible(
            child: new TaskText(
              task: task,
              bottomWidget: new BottomRowTasks(
                task: task,
              ),
            ),
          )
        ],
      );
    }

}

class HabitTask extends StatelessWidget {
  HabitTask({
    Key key,
    this.task,
    this.plusOneTask,
    this.minusOneTask
  }):super(key:key);

  final Task task;
  final void Function() plusOneTask;
  final void Function() minusOneTask;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Row(
        children: <Widget>[
          new IconButton(
            onPressed: (task.up != null && task.up ? plusOneTask : null),
            icon: new Icon(Icons.add),
          ),
          new Flexible(
            child: new TaskText(
              task: task,
              bottomWidget: new BottomRowHabits(task: task)
            ),
          ),
          new IconButton(
            onPressed: (task.down != null && task.down ? minusOneTask : null),
            icon: new Icon(Icons.remove),
          ),
        ],
      );
    }
}

class TaskText extends StatelessWidget {
  TaskText({Key key, this.task, this.bottomWidget}):super(key: key);

  final Task task;
  final StatelessWidget bottomWidget;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 64.0
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: new MarkdownBody(
                styleSheet: new MarkdownStyleSheet.fromTheme(mainTheme),
                data: convertEmojis(task.text),
              ),
            ),
            new Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: bottomWidget
            )
          ],
        ),
      );
    }
}

class BottomRowTasks extends StatelessWidget {
  BottomRowTasks({Key key, this.task}):super(key: key);
  final Task task;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return (
        task.date != null ?
        new Text(
          new Moment.fromDate(new DateTime.now()).from(DateTime.parse(task.date)),
          style: mainTheme.textTheme.caption
        ) :
        new Text("")
      );
    }
}

class BottomRowHabits extends StatelessWidget {
  BottomRowHabits({Key key, this.task}):super(key: key);
  final Task task;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Row(
        children: <Widget>[
          new Icon(Icons.fast_forward),
          new Text("+${task.counterUp} | -${task.counterDown}"),
        ],
      );
    }
}

class BottomRowDailys extends StatelessWidget {
  BottomRowDailys({Key key, this.task}):super(key: key);
  final Task task;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Row(
        children: <Widget>[
          new Icon(Icons.fast_forward),
          new Text("${task.streak}"),
        ],
      );
    }
} 
