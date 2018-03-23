import 'dart:async';
import 'dart:collection';
import 'package:uuid/uuid.dart';

import '../api/tasks.dart';
import '../helpers/savedlogin.dart';

import '../models/task.dart';
import '../actions/tasks.dart';
import '../store.dart';

import 'base.dart';
import 'user.dart';

final _taskProvider = new TaskProvider(table: "tasks");
final uuid = new Uuid();


getOfflineTasks() async {
  return await getOfflineObjects(_taskProvider, tasksstore, (objects) => TaskAction.populateTasks(objects));
}


Future<Null> getNetworkTasks() async {
  try {
    tasksstore.dispatch(TaskAction.startLoading());
    var loginInformation = await getLoginInformation();
    List<Task> data = await getTasks(loginInformation: loginInformation);
    if(data == null) {
      return;
    }
    tasksstore.dispatch(TaskAction.populateTasks(data));
    tasksstore.dispatch(TaskAction.stopLoading());
    syncTasks(data);
    getNetworkUser();
  } catch(e) {
    print(e);
  }
}

onNewTask(String text, String type) async {
  var loginInformation = await getLoginInformation();
  Task task = new Task(LinkedHashMap.from({
    'type': type,
    'id': uuid.v1(),
    'text': text,
  }));
  tasksstore.dispatch(TaskAction.addTask(task));
  tasksstore.dispatch(TaskAction.startLoading());
  userstore.state.user.tasksOrder.habits.insert(0, task.id);
  try {
    Task addedTask = await addNewTask(
      new Task(LinkedHashMap.from({'text': text, 'type': type})),
      loginInformation
    );
    int foundTaskIndex = tasksstore.state.tasks.lastIndexWhere((Task checkingTask) {
      return checkingTask.id == task.id;
    });
    userstore.state.user.tasksOrder.habits[userstore.state.user.tasksOrder.habits.indexOf(task.id)] = addedTask.id;
    tasksstore.dispatch(TaskAction.replaceTask(foundTaskIndex, addedTask));
    tasksstore.dispatch(TaskAction.stopLoading());
    syncTasks(tasksstore.state.tasks);
  } catch(e) {
    print(e);
  }
}

onEditTask(Task task) async{
  var loginInformation = await getLoginInformation();
  int foundTaskIndex = tasksstore.state.tasks.indexWhere((Task checkingTask) {
    return checkingTask.id == task.id;
  });
  tasksstore.dispatch(TaskAction.replaceTask(foundTaskIndex, task));
  tasksstore.dispatch(TaskAction.startLoading());
  try {
    Task editedTask = await editTask(task, loginInformation);
    tasksstore.dispatch(TaskAction.replaceTask(foundTaskIndex, editedTask));
    tasksstore.dispatch(TaskAction.stopLoading());
    syncTasks(tasksstore.state.tasks);
  } catch(e) {
    print(e);
  }
}

onTaskScore(Task task, bool direction) async {
  var loginInformation = await getLoginInformation();
  int foundTaskIndex = tasksstore.state.tasks.indexWhere((Task checkingTask) {
    return checkingTask.id == task.id;
  });
  tasksstore.dispatch(TaskAction.replaceTask(foundTaskIndex, task));
  tasksstore.dispatch(TaskAction.startLoading());
  try {
    await scoreTask(task, direction, loginInformation);
    // tasksstore.dispatch(TaskAction.replaceTask(foundTaskIndex, editedTask));
    tasksstore.dispatch(TaskAction.stopLoading());
    syncTasks(tasksstore.state.tasks);
  } catch(e) {
    print(e);
  }
}

syncTasks(tasks) async {
  syncObject(_taskProvider, tasks);
}


clearTasks() {
  tasksstore.dispatch(TaskAction.clear());
}
