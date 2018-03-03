import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final String columnId = "_id";
final String columnUserId = "userId";
final String columnText = "text";
final String columnType = "type";
final String columnUp = "up";
final String columnDown = "down";
final String columnDate = "date";

class Task {
  Task(Map<String, dynamic> map) {
    id = map[columnId];
    userId = map[columnUserId];
    text = map[columnText];
    type = map[columnType];
    up = map[columnUp];
    down = map[columnDown];
    date = map[columnDate];
  }

  Map<String, dynamic> toMap() {
    Map map = {
      columnUserId: userId,
      columnText: text,
      columnId: id,
      columnType: type,
      columnUp: up,
      columnDown: down,
      columnDate: date
    };
    return map;
  }

  String id;
  String userId;
  String text;
  String type;
  bool up = false;
  bool down = false;
  String date;

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
