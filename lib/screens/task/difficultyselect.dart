import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import '../../models/task.dart';
import 'subhead.dart';

class DifficultySelect extends StatelessWidget {
  DifficultySelect({this.onChanged, this.value}):super();

  @required
  final void Function(dynamic) onChanged;

  final Difficulty value;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
        children: <Widget>[
          new SubHead("Difficulty"),
          new ListTile(
            dense: true,
            title: new DropdownButton(
              hint: new Text("Difficulty"),
              onChanged: onChanged,
              value: value,
              items:  
                Difficulty.values.map((Difficulty diff) => 
                  new DropdownMenuItem(
                    value: diff,
                    child: new Text(diffToPrint[diff]),
                  )).toList()
              ,
            ),
          ),
        ],
      );
    }
}
