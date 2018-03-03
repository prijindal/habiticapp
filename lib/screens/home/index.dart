import 'package:flutter/material.dart';

import 'taskinput.dart';
import 'task.dart';

class HomePage extends StatelessWidget {
  HomePage({ Key key, this.onLoggedOut }): super(key: key);  
  final String title = "Home Page";
  final Function onLoggedOut;  

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          elevation: 4.0,
          title: new Text(this.title),
          actions: <Widget>[
            new IconButton(
              onPressed: onLoggedOut,
              icon: new Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: new Container(
          child: new HomePageBody()
        )
      );
    }
}

class HomePageBody extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePageBody> {
  bool _enableAddTask = false;
  List<TaskContainer> _tasks = <TaskContainer>[];

  _onNewTask(String task) {
    TaskContainer taskContainer = new TaskContainer(
      text: task,
    );
    setState(() {
      _tasks.add(taskContainer);
    });
  }

  @override
    Widget build(BuildContext context) {
      return new Stack(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  itemBuilder: (_, int index) => _tasks[index],
                  itemCount: _tasks.length,
                )
              ),
              new Container(
                child: (
                  _enableAddTask ?
                  new AddTaskInput(
                    onBackButton:() {
                      setState(() {
                        _enableAddTask = false;
                      });
                    },
                    onSubmit: _onNewTask
                  ) :
                  null
                )
              )
            ]
          ),
          new Container(
            child: (_enableAddTask ?
              null :
              new AddTaskFloating(
                onPressed: () {
                  setState(() {
                    _enableAddTask = true;
                  });
                }
              )
            )
          )
        ],
      );
    }
}

class AddTaskFloating extends StatelessWidget {
  AddTaskFloating({Key key, this.onPressed}): super(key: key);

  final Function onPressed;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Positioned(
        bottom: 16.0,
        right: 16.0,
        child: new Container(
          child: new FloatingActionButton(
            onPressed: onPressed,
            child: const Icon(Icons.add),
          ),
        ),
      );
    }
}
