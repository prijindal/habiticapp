import 'package:Habitter/models/task.dart';
import 'package:Habitter/screens/task/index.dart';
import 'package:Habitter/routes/root.dart';
import 'package:Habitter/helpers/theme.dart';
import 'package:flutter/material.dart';

Task habit = new Task({
  "priority": 0.1,
  "id": "1a4851f9-8839-49cc-862d-3ef09e54584c",
  "tags": [
    "5d3a247c-6f31-4dc5-9074-6b22d6737955"
  ],
  "notes": "",
  "userId": "087ff527-8d8b-4480-8c71-8617891a0f4b",
  "text": "This a new task",
  "type": "habit",
  "up": true,
  "down": false,
  "streak": 0 
});

Task todo = new Task({
  "id": "542ac714-9802-4f04-af60-d4e5e517d95b",
  "userId": "087ff527-8d8b-4480-8c71-8617891a0f4b",
  "text": "New todo",
  "type": "todo",
  "tags": [],
  "checklist": [],
  "priority": 0.1,
  "notes": "", 
  "up": false,
  "down": false,
  "streak": 0,
});

Task daily = new Task({
  "id": "89bf1551-bb92-400c-be42-0e1e9fd59a85",
  "userId": "087ff527-8d8b-4480-8c71-8617891a0f4b",
  "text": "New daily",
  "type": "daily",
  "tags": [],
  "priority": 0.1,
  "notes": "", 
  "up": false, 
  "down": false, 
  "streak": 0
});


void main() => runApp(
  new RootApplication(
    initialScreen: new MaterialApp(
      theme: mainTheme,
      home: new TaskScreen(task: daily),
    )
  )
);
