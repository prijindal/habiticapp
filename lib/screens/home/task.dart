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
          title: new Container(
            child: new Row(
              children: <Widget>[
                new IconButton(
                  onPressed: (task.up != null && task.up ? _plusOneTask : null),
                  icon: new Icon(Icons.add),
                ),
                new Flexible(
                  child: new TaskText(task: task),
                ),
                new IconButton(
                  onPressed: (task.down != null && task.down ? _minusOneTask : null),
                  icon: new Icon(Icons.remove),
                ),
              ],
            ),
          )
        )
      );
    }
}

class TaskText extends StatelessWidget {
  TaskText({Key key, this.task}):super(key: key);

  final Task task;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
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
            child: (
              task.date != null ?
              new Text(
                new Moment.fromDate(DateTime.parse(task.date)).from(new DateTime.now()),
                style: mainTheme.textTheme.caption
              ) :
              null
            )
          )
        ],
      );
    }
}
