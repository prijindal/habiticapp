import 'dart:async';
import 'base.dart';

import '../models/task.dart';
import 'login.class.dart';

Future<List<Task>> getTasks({String type, LoginResponse loginInformation}) async {
  var url = "/tasks/user";
  var query = {};
  if(type != null) {
    query["type"] = type;
  }
  Map<String, dynamic> responseJson = await get(url, query, loginInformation);
  List<Map<String, dynamic>> data = responseJson['data'];
  List<Task> tasks = data.map((task) => new Task(task)).toList();
  return tasks;
}

Future<Task> addNewTask(Task task, LoginResponse loginInformation) async {
  var url = "/tasks/user";
  Map<String, dynamic> responseJson = await post(url, task.toMap(), null, loginInformation);
  if(responseJson['success'] == true) {
    Map<String, dynamic> data = responseJson['data'];
    return new Task(data);
  } else {
    throw new Exception(responseJson['error']);
  }
}

Future<Task> getTask(String id, LoginResponse loginInformation) async {
  var url = "/tasks/$id";
  Map<String, dynamic> responseJson = await get(url, {}, loginInformation);
  if(responseJson['success'] == true) {
    Map<String, dynamic> data = responseJson['data'];    
    return new Task(data);
  } else {
    throw new Exception(responseJson['error']);
  }
}

Future<Task> editTask(Task task, LoginResponse loginInformation) async {
  var url = "/tasks/${task.id}";
  Map<String, dynamic> responseJson = await put(url, task.toMap(), {}, loginInformation);
  if(responseJson['success'] == true) {
    Map<String, dynamic> data = responseJson['data'];    
    return new Task(data);
  } else {
    throw new Exception(responseJson['error']);
  }
}
