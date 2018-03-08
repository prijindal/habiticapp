import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';

import '../../models/task.dart';
import '../../helpers/markdown.dart';


import '../../helpers/theme.dart';

// import '../../api/tasks.dart';
// import '../../helpers/savedlogin.dart';

import '../../sagas/tasks.dart';

import '../../store.dart';

import '../task/index.dart';
import '../../libraries/markdown/flutter_markdown.dart';

class TaskContainer extends StatefulWidget{
  TaskContainer({Key key, this.task, this.onChanged}):super(key: key);
  final Task task;
  final void Function(Task task) onChanged;

  @override
  _TaskContainerState createState() => new _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  bool _isSelected = false;
  bool _isLoading = false;

  _toggleSelected() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  _openTaskPage(BuildContext context) async {
    Task updatedTask = await Navigator.of(context).push(
      new TaskPageRoute<Task>(
        builder: (BuildContext context) => new TaskScreen(task: widget.task),
      )
    );
    if(updatedTask == null) return;
    setState(() {
      _isLoading = true;
    });
    await _updateTask(updatedTask);
  }

  _updateTask(Task updatedTask) async {
    _callUpdateTask(updatedTask);
    await onEditTask(updatedTask);
    if(!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  int _getIndex() {
    var index = tasksstore.state.tasks.indexWhere((task) => task.id == widget.task.id);
    return index;
  }
  
  _callUpdateTask(Task updatedTask) {
    if(widget.onChanged != null) {
      widget.onChanged(updatedTask);
    }
    setState(() {
      _isLoading = true;
    });
  }

  _plusOneTask() async {
    var index = _getIndex();
    tasksstore.state.tasks[index].counterUp = tasksstore.state.tasks[index].counterUp + 1;
    _callUpdateTask(tasksstore.state.tasks[index]);
    await onTaskScore(tasksstore.state.tasks[index], false);
    if(!mounted) return;
    setState(() {
      _isLoading = false;
    });
    // Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Hello")));
  }

  _minusOneTask() async {
    var index = _getIndex();
    tasksstore.state.tasks[index].counterDown = tasksstore.state.tasks[index].counterDown + 1;
    _callUpdateTask(tasksstore.state.tasks[index]);
    await onTaskScore(tasksstore.state.tasks[index], false);
    if(!mounted) return;
    setState(() {
      _isLoading = false;
    });
    // Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Hello")));
  }

  _onTodoToggled(dynamic newValue) async {
    var index = _getIndex();
    tasksstore.state.tasks[index].completed = newValue;
    _callUpdateTask(tasksstore.state.tasks[index]);
    await onTaskScore(tasksstore.state.tasks[index], newValue);
    if(!mounted) return;
    setState(() {
      _isLoading = false;
    });
    // Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Not yet implemented")));
  }

  _onDailyDone(bool newValue) async {
    var index = _getIndex();
    tasksstore.state.tasks[index].completed = newValue;
    _callUpdateTask(tasksstore.state.tasks[index]);
    await onTaskScore(tasksstore.state.tasks[index], newValue);
    if(!mounted) return;
    setState(() {
      _isLoading = false;
    });
    // Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Not yet implemented")));
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Hero(
        tag: widget.task.id,
        child: new Material(
          elevation: (
            (_isLoading || widget.task.notes == null) ?
            8.0 :
            0.0
          ),
          color: (
            _isSelected ?
            Colors.black26:
            null
          ),
          child: new ListTile(
            trailing: new AnimatedCrossFade(
              duration: new Duration(milliseconds: 100),
              crossFadeState: (_isLoading || widget.task.notes == null) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              alignment: Alignment.bottomRight,
              firstChild: new Container(
                constraints: const BoxConstraints(
                  maxWidth: 16.0,
                  maxHeight: 16.0,
                ),
                child: new Container(
                  margin: const EdgeInsets.all(2.0),
                  child: new CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                )
              ),
              secondChild: new Container(),
            ),
            enabled: !(_isLoading || widget.task.notes == null),
            onTap: (
              _isSelected ?
              _toggleSelected :
              () => _openTaskPage(context)
            ),
            onLongPress: _toggleSelected,
            selected: _isSelected,
            title: _buildTaskComponent(),
          )
        )
      );
    }

  _buildTaskComponent() {
    switch (widget.task.type) {
      case "todo":
        return new TodoTask(
          task: widget.task,
          onTodoToggled: _onTodoToggled,
        );
        break;
      case "habit":
        return new HabitTask(
          task: widget.task,
          plusOneTask: _plusOneTask,
          minusOneTask: _minusOneTask,
        );
        break;
      case "daily":
        return new DailyTask(
          task: widget.task,
          onDailyDone: _onDailyDone
        );
      default:
        return new Text(widget.task.text);
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
          new Checkbox(
            value: task.completed,
            onChanged: onTodoToggled,
          ),
          new Flexible(
            child: new TaskText(
              task: task,
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
  TaskText({Key key, this.task}):super(key: key);

  final Task task;

  StatelessWidget _buildBottomWidget() {
    switch (task.type) {
      case "todo":
        return new BottomRowTasks(task: task);
      case "habit":
        return new BottomRowHabits(task: task);
        break;
      case "daily":
        return new BottomRowDailys(task: task);
      default:
        return new Container();
    }
  }
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 64.0
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(top: 8.0),
              child: new MarkDownTaskText(
                text: task.text,
                textStyle: mainTheme.textTheme.body1
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.bottomLeft,
                  child: _buildBottomWidget()
                ),
              ],
            )
          ],
        ),
      );
    }
}

class MarkDownTaskText  extends StatelessWidget {
  MarkDownTaskText({Key key, this.text, this.textStyle}):super(key: key);

  final String text;
  final TextStyle textStyle;
  @override
    Widget build(BuildContext context) {
      return new Container(
        child: new MarkdownBody(
          data: convertEmojis(text),
          styleSheet: new MarkdownStyleSheet.fromTheme(mainTheme),
        ),
      );
    }
}

class BottomRowTasks extends StatelessWidget {
  BottomRowTasks({Key key, this.task}):super(key: key);
  final Task task;

  String _getFromNowDate() {
    if(task.date == null) {
      return "";
    }
    try {
      return new Moment.fromDate(new DateTime.now()).from(DateTime.parse(task.date));
    } catch(e) {
      return "";
    }
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Text(
        _getFromNowDate(),
        style: mainTheme.textTheme.caption
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
          new Icon(
            Icons.fast_forward,
            color: mainTheme.textTheme.caption.color,
          ),
          new Text(
            "+${task.counterUp} | -${task.counterDown}",
            style: mainTheme.textTheme.caption
          ),
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
          new Icon(
            Icons.fast_forward,
            color: mainTheme.textTheme.caption.color,
          ),
          new Text(
            "${task.streak}",
            style: mainTheme.textTheme.caption
          ),
        ],
      );
    }
} 
