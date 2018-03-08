// import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../home/task.dart';
import '../../models/task.dart';
import '../../models/tag.dart';
import '../../store.dart';

import 'difficultyselect.dart';
import 'tagselect.dart';

import 'advance.dart';

// import '../helpers/theme.dart';
// import '../helpers/savedlogin.dart';
// import '../api/tasks.dart';

class TaskPageRoute<T> extends MaterialPageRoute<T> {
  TaskPageRoute({ WidgetBuilder builder })
      : super(builder: builder, fullscreenDialog: true);

  @override
    Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      // TODO: implement buildTransitions
      if(settings.isInitialRoute) {
        return child;
      }
      return new FadeTransition(opacity: animation, child: child,);
    }
}

class TaskScreen extends StatefulWidget {
  TaskScreen({ Key key, this.task }): super(key: key);

  @required
  final Task task;

  @override
  _TaskScreenState createState() => new _TaskScreenState(task: task);
}

class _TaskScreenState extends State<TaskScreen> {
  _TaskScreenState({this.task}):super() {
    task = new Task(this.task.toMap());
  }

  @required
  Task task;

  TextEditingController textEditingController = new TextEditingController();
  TextEditingController notesEditingController = new TextEditingController();

  int textLines = 2;
  int notesLines = 2;

  @override
    void initState() {
      super.initState();
      notesEditingController.text = task.notes;
      textEditingController.text = task.text;
      setState(() {
        textLines = getLines(task.text);
        notesLines = getLines(task.notes);
      });
      textEditingController.addListener(_textOnChanged);
      notesEditingController.addListener(_notesOnChanged);
    }
  
  @override
    dispose() {
      textEditingController.removeListener(_textOnChanged);
      notesEditingController.removeListener(_textOnChanged);
      textEditingController.dispose();
      notesEditingController.dispose();
      super.dispose();
    }

  int getLines(String text) {
    var maxLines = text.split('\n').length;
    if(maxLines <= 1) {
      maxLines = 2;
    }
    return maxLines;
  }

  _textOnChanged() {
    var newText = textEditingController.text;
    setState(() {
      textLines = getLines(newText);
      task.text = newText;
    });
  }

  _notesOnChanged() {
    var nextnotes = notesEditingController.text;
    setState(() {
      notesLines = getLines(nextnotes);
      task.notes = nextnotes;
    });
  }

  _onSave() {
    Navigator.of(context).pop();
  }

  _onChanged(Tag changedTag, bool newValue) {
    for(var i = 0;i < userstore.state.user.tags.length; i+=1) {
      if(userstore.state.user.tags[i].id == changedTag.id) {
        if(newValue) {
          // add to task.tags based on newValue
          setState(() {
            task.tags.add(changedTag.id);
          });
        } else {
          setState(() {
            task.tags.remove(changedTag.id);
          });
        }
      }
    }
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Edit ${(task.type != null ? task.type: "task")}"),
          actions: <Widget>[
            new FlatButton(
              onPressed: _onSave,
              child: new Text(
                "Save",
                style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        body: new ListView(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new TaskContainer(
                task: widget.task,
                // text: (task.text != null ? task.text: ""),
                // textStyle: mainTheme.textTheme.body1
              ),
            ),
            new ListTile(
              title: new TextField(
                controller: textEditingController,
                decoration: new InputDecoration(
                  hintText: "Enter A Text",
                  labelText: "Text"
                ),
                keyboardType: TextInputType.multiline,
                maxLines: textLines,
              ),
            ),
            new ListTile(
              title: new TextField(
                controller: notesEditingController,
                decoration: new InputDecoration(
                  hintText: "Enter A notes",
                  labelText: "Notes"
                ),
                keyboardType: TextInputType.multiline,
                maxLines: notesLines,
              ),
            ),
            new DifficultySelect(
              onChanged: (diff) {
                setState(() {
                  task.difficulty = diff;
                });
              },
              value: task.difficulty,
            ),
            new TaskScreenAdvance(
              task: task,
              onChanged: (Task newTask) {
                setState(() {
                  task = newTask;
                });
              },
            ),
            new TagsSelect(
              task: task,
              onChanged: _onChanged,
            )
          ],
        ),
      );
    }
}
