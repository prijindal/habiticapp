import 'package:uuid/uuid.dart';

import '../api/tasks.dart';
import '../helpers/savedlogin.dart';

import '../models/task.dart';
import '../actions/tasks.dart';
import '../store.dart';

import 'base.dart';

final _taskProvider = new TaskProvider(table: "tasks");
final uuid = new Uuid();


getOfflineTasks() async {
  return await getOfflineObjects(_taskProvider, tasksstore, (objects) => TaskAction.populateTasks(objects));
}


getNetworkTasks() async {
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
  } catch(e) {
    print(e);
  }
}

onNewTask(String text, String type) async {
  var loginInformation = await getLoginInformation();
  Task task = new Task({
    'type': type,
    'id': uuid.v1(),
    'text': text,
  });
  tasksstore.dispatch(TaskAction.addTask(task));
  tasksstore.dispatch(TaskAction.startLoading());
  try {
    Task addedTask = await addNewTask(new Task({'text': text, 'type': type}), loginInformation);
    int foundTaskIndex = tasksstore.state.tasks.lastIndexWhere((Task checkingTask) {
      return checkingTask.id == task.id;
    });
    tasksstore.dispatch(TaskAction.replaceTask(foundTaskIndex, addedTask));
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