import 'package:flutter/material.dart';

class TaskContainer extends StatelessWidget {
  TaskContainer({Key key, this.text}):super(key: key);
  
  final String text;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        child: new Text(text)
      );
    }
}
