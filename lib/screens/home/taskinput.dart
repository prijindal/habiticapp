import 'package:flutter/material.dart';
import 'dart:async';

class AddTaskInput extends StatefulWidget {
  AddTaskInput({Key key, this.onBackButton, this.onSubmit}): super(key: key);

  final Function() onBackButton;
  final Function(String text) onSubmit;

  @override
  _AddTaskInputState createState() => new _AddTaskInputState();
}

class _AddTaskInputState extends State<AddTaskInput> implements WidgetsBindingObserver {
  TextEditingController _addTaskController = new TextEditingController();
  FocusNode _addTaskFocusNode = new FocusNode();

  bool isKeyboardClosed = true;
  bool _isComposing = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    this._focusKeyboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if(!isKeyboardClosed) {
      this._unFocusKeyboard();
      // isKeyboardClosed = true;
    } else {
      isKeyboardClosed = false;
    }
  }

  _focusKeyboard() async {
    FocusScope.of(context).requestFocus(_addTaskFocusNode);    
  }

  _unFocusKeyboard() async {
    _addTaskFocusNode.unfocus();
    widget.onBackButton();
  }

  _onPressed() {
    widget.onSubmit(_addTaskController.text);    
    _addTaskController.clear();
    _unFocusKeyboard();
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
                  child: new TextField(
                    controller: _addTaskController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
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
                  onPressed: (
                    _isComposing ?
                    _onPressed:
                    null
                  ),
                  icon: new Icon(Icons.send),
                ),
              )
            ],
          ),
        ),
      );
      return iconTheme;
    }
}
