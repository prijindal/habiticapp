import 'package:uuid/uuid.dart';

import '../api/login.class.dart';
import '../api/tasks.dart';
import '../helpers/savedlogin.dart';

import '../models/task.dart';
import '../actions/tasks.dart';
import '../store.dart';

final _taskProvider = new TaskProvider(tableTask: "tasks");
final uuid = new Uuid();

getOfflineTasks() async {
  try {
    await _taskProvider.open();
    List<Task> newtasks = await _taskProvider.getTasks();
    if(newtasks == null) {
      return;
    }
    store.dispatch(populateTasks(newtasks));
  } catch(e) {
    print("SAGAS, Error:" + e.toString());
    print(e);
  }
}


getNetworkTasks() async {
  try {
    store.dispatch(startLoading());
    var loginInformation = await getLoginInformation();
    List<Task> data = await getTasks(loginInformation: loginInformation);
    if(data == null) {
      return;
    }
    store.dispatch(populateTasks(data));
    store.dispatch(stopLoading());
    syncTasks(store.state.tasks);
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
  store.dispatch(addTask(task));
  store.dispatch(startLoading());
  try {
    Task addedTask = await addNewTask(new Task({'text': text, 'type': type}), loginInformation);
    int foundTaskIndex = store.state.tasks.lastIndexWhere((Task checkingTask) {
      return checkingTask.id == task.id;
    });
    store.dispatch(replaceTask(foundTaskIndex, addedTask));
    store.dispatch(stopLoading());
    syncTasks(store.state.tasks);
  } catch(e) {
    print(e);
  }
}

syncTasks(tasks) async {
  try {
    await _taskProvider.sync(tasks);
  } catch(e) {
    print(e);
  }
}
