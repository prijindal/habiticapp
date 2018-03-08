import 'package:Habitter/models/task.dart';
import 'package:Habitter/screens/task/index.dart';
import 'package:Habitter/routes/root.dart';
import 'package:Habitter/helpers/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  new RootApplication(
    initialScreen: new MaterialApp(
      theme: mainTheme,
      home: new TaskScreen(task: new Task({
        "priority": 0.1,
        "id": "1a4851f9-8839-49cc-862d-3ef09e54584c",
        "tags": [
          "5d3a247c-6f31-4dc5-9074-6b22d6737955"
        ],
        "notes": "",
        "userId": "087ff527-8d8b-4480-8c71-8617891a0f4b",
        "text": "This a new task",
        "type": "habit",
        "up": false,
        "down": false,
        "streak": 0 
      }),),
    )
  )
);
