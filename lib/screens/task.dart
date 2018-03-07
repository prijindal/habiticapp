// import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'home/task.dart';
import '../models/task.dart';

import '../helpers/theme.dart';
import '../helpers/savedlogin.dart';
import '../api/tasks.dart';

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
  _TaskScreenState({this.task}):super()  {
    this.task = new Task(task.toMap());
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
      getNetworkTask();
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

  getNetworkTask() async {
    try {
      var loginInformation = await getLoginInformation();
      Task newTask = await getTask(task.id, loginInformation);
      print(newTask);
      setState(() {
        task = newTask;
      });
    } catch(e) {
      print(e);
    }
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
            new ListTile(
              title: new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new MarkDownTaskText(
                  text: (task.text != null ? task.text: ""),
                  textStyle: mainTheme.textTheme.body1
                ),
              )
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
              onChanged: (diff) {},
            )
          ],
        ),
      );
    }
}

class DifficultySelect extends StatelessWidget {
  DifficultySelect({this.onChanged}):super();

  @required
  final void Function(dynamic) onChanged;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new ListTile(
        title: new DropdownButton(
          onChanged: onChanged,
          items:  
            Difficulty.values.map((Difficulty diff) => 
              new DropdownMenuItem(
                child: new Text(diff.toString()),
              )).toList()
          ,
        ),
      );
    }
}
