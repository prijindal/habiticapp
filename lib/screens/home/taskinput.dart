import 'package:flutter/material.dart';
import 'dart:async';

class AddTaskInput extends StatefulWidget {
  AddTaskInput({Key key, this.onBackButton}): super(key: key);

  Function onBackButton;

  @override
  _AddTaskInputState createState() => new _AddTaskInputState();
}

class _AddTaskInputState extends State<AddTaskInput> implements WidgetsBindingObserver {
  TextEditingController _addTaskController = new TextEditingController();
  FocusNode _addTaskFocusNode = new FocusNode();

  bool isKeyboardClosed = true;
  bool isFirstLoad = true;

  _focusOnInput(BuildContext context) async {
    FocusScope.of(context).requestFocus(_addTaskFocusNode);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
    void dispose() {
      WidgetsBinding.instance.removeObserver(this);
      super.dispose();
    }

  @override
  void didChangeMetrics() {
    if(!isKeyboardClosed) {
      _addTaskFocusNode.unfocus();
      widget.onBackButton();
      // isKeyboardClosed = true;
    } else {
      isKeyboardClosed = false;
    }
    // setState(() {
    //   isKeyboardClosed = true;
    // });
    // WidgetsBinding.instance.removeObserver(this);
    // super.didChangeMetrics();
  }

  _checkKeyboardFocus(Timer timer) {
    print(_addTaskFocusNode.hasFocus);
    print(_addTaskFocusNode.runtimeType);
    print(_addTaskFocusNode.toString());
  }

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      IconTheme iconTheme = new IconTheme(
        data: new IconThemeData(
          color: Theme.of(context).accentColor
        ),
        child: new Container(
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new Container(
                  child: new TextFormField(
                    controller: _addTaskController,
                    focusNode: _addTaskFocusNode,
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                      hintText: "Add a habit",
                    ),
                  ),
                ),
              ),
              new Container(
                child: new IconButton(
                  onPressed: () => {},
                  icon: new Icon(Icons.send),
                ),
              )
            ],
          ),
        ),
      );
      if (isKeyboardClosed) {
        this._focusOnInput(context);
      }
      return iconTheme;
    }
}
