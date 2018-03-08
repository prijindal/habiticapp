import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../models/tag.dart';
import '../../store.dart';

import '../../helpers/theme.dart';

class TagsSelect extends StatelessWidget {
  TagsSelect({ Key key, this.task, this.onChanged }): super(key: key);

  @required
  final void Function(Tag, bool) onChanged;

  @required
  final Task task;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 16.0, top: 16.0),
            alignment: Alignment.bottomLeft,
            child: new Text("Tags",
              textAlign: TextAlign.left,
              style: mainTheme.textTheme.caption
            ),
          ),
          new Column(
            children: userstore.state.user.tags.map((Tag tag) => 
              new CheckboxListTile(
                onChanged: (bool newValue) => onChanged(tag, newValue),
                value: task.tags.contains(tag.id),
                title: new Text(tag.name)
              )).toList(),
          )
        ]
      );
    }
}
