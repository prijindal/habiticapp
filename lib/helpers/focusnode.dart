import 'package:flutter/material.dart';

class AutoDisabledFocusNode extends FocusNode {
  AutoDisabledFocusNode({this.isEnabled}): super();
  bool isEnabled;
  @override
  bool get hasFocus => this.isEnabled;
}
