import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final String columnId = "_id";
final String columnUserId = "userId";
final String columnText = "text";

class Task {
  Task(Map<String, dynamic> map) {
    _id = map[columnId];
    userId = map[columnUserId];
    text = map[columnText];
  }

  Map<String, dynamic> toMap() {
    Map map = {columnUserId: userId, columnText: text, columnId: _id};
    return map;
  }

  String _id;
  String userId;
  String text;

  @override
    String toString() {
      return toMap().toString();
    }
}

class TaskProvider {
  SharedPreferences prefs;
  final String tableTask;

  TaskProvider({this.tableTask});

  Future open() async {
    prefs = await SharedPreferences.getInstance();
    return;
  }

  Future<List<Task>> getTasks() async {
    String maps = prefs.getString(tableTask);
    List<dynamic> tasks = JSON.decode(maps);
    return tasks.map((task) => new Task(task)).toList();
  }

  Future<void> sync([List<Task> tasks]) async {
    prefs.setString(tableTask, JSON.encode(tasks.map((task) => task.toMap()).toList()));
  }

  Future<bool> close() => prefs.commit();
}
