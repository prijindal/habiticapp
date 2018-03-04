import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final String columnId = "id";
final String columnUserId = "userId";
final String columnText = "text";
final String columnType = "type";
final String columnUp = "up";
final String columnDown = "down";
final String columnDate = "date";
final String columnCompleted = "completed";
final String columnCounterUp = "counterUp";
final String columnCounterDown = "counterDown";
final String columnStreak = "streak";

final List<String> columns = [
  columnId,
  columnUserId,
  columnText,
  columnType,
  columnUp,
  columnDown,
  columnDate,
  columnCompleted,
  columnCounterUp,
  columnCounterDown,
  columnStreak,
];

class Task {
  Task(Map<String, dynamic> map) {
    id = getDefaultMap(map, columnId);
    userId = getDefaultMap(map, columnUserId);
    text = getDefaultMap(map, columnText);
    type = getDefaultMap(map, columnType);
    date = getDefaultMap(map, columnDate);

    up = getDefaultMap(map, columnUp, false);
    down = getDefaultMap(map, columnDown, false);
    completed = getDefaultMap(map, columnCompleted, false);
    counterUp = getDefaultMap(map, columnCounterUp, 0);
    counterDown = getDefaultMap(map, columnCounterDown, 0);
    streak = getDefaultMap(map, columnStreak, 0);
  }

  dynamic getDefaultMap(Map<String, dynamic> map, String column, [dynamic defaultValue]) {
    if(map.containsKey(column)) {
      return map[column];
    } else {
      return defaultValue;
    }
  }

  Map<String, dynamic> toMap() {
    Map map = {
      // columnId: id,      
      // columnUserId: userId,
      columnText: text,
      columnType: type,
    };
    map = checkNullAndAdd(map, columnDate, date);
    map = checkNullAndAdd(map, columnUp, up);
    map = checkNullAndAdd(map, columnDown, down);
    map = checkNullAndAdd(map, columnStreak, streak);
    return map;
  }

  dynamic checkNullAndAdd(Map<String, dynamic> map, String key, dynamic value) {
    if (value != null) {
      map[key] = value;
    }
    return map;
  }

  String id;
  String userId;
  String text;
  String type;
  bool up;
  bool down;
  String date;
  bool completed;
  int counterDown;
  int counterUp;
  int streak;

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
    if(maps == null) {return null;}
    List<dynamic> tasks = JSON.decode(maps);
    return tasks.map((task) => new Task(task)).toList();
  }

  Future<void> sync([List<Task> tasks]) async {
    prefs.setString(tableTask, JSON.encode(tasks.map((task) => task.toMap()).toList()));
  }

  Future<bool> close() => prefs.commit();
}
