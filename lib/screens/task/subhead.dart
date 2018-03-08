import 'package:flutter/material.dart';
import '../../helpers/theme.dart';

class SubHead extends StatelessWidget {
  SubHead(this.text, {Key key}):super(key: key);
  final String text;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        margin: const EdgeInsets.only(left: 16.0, top: 32.0),
        alignment: Alignment.bottomLeft,
        child: new Text(text,
          textAlign: TextAlign.left,
          style: mainTheme.textTheme.caption
        ),
      );
    }
}
