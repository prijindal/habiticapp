import 'dart:async';
import 'base.dart';

import '../models/task.dart';
import 'login.class.dart';

Future<List<Task>> getTasks({String type, LoginResponse loginInformation}) async {
  var url = "/tasks/user";
  Map<String, dynamic> responseJson = await get(url, {"type": type}, loginInformation);
  List<Map<String, dynamic>> data = responseJson['data'];
  List<Task> tasks = data.map((task) => new Task(task)).toList();
  return tasks;
}
