import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../libraries/markdown/flutter_markdown.dart';
import '../../helpers/markdown.dart';

import '../../helpers/theme.dart';

import '../task.dart';

class TaskContainer extends StatefulWidget {
  TaskContainer({Key key, this.task}):super(key: key);
  final Task task;

  @override
  _TaskContainerState createState() => new _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  bool _isSelected = false;

  _toggleSelected() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  _openTaskPage(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) => new TaskScreen(task: widget.task),
      )
    );
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        color: (
          _isSelected ?
          Colors.purple[100]:
          null
        ),
        child: new ListTile(
          enabled: true,
          selected: _isSelected,
          onTap: (
            _isSelected ?
            _toggleSelected :
            () => _openTaskPage(context)
          ),
          onLongPress: _toggleSelected,
          title: new MarkdownBody(
            styleSheet: new MarkdownStyleSheet.fromTheme(mainTheme),
            data: convertEmojis(widget.task.text),
          )
        )
      );
    }
}
