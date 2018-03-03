import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../libraries/markdown/flutter_markdown.dart';
import '../../helpers/markdown.dart';

class TaskContainer extends StatelessWidget {
  TaskContainer({Key key, this.task}):super(key: key);
  
  final Task task;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        child: new ListTile(
          title: new MarkdownBody(
            data: convertEmojis(task.text),
          )
        )
      );
    }
}
