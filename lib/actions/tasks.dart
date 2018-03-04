import '../models/task.dart';

enum Actions {
  AddTask,
  PopulateTasks,
  ReplaceTask,
  StartLoading,
  StopLoading
}

class TaskAction {
  TaskAction({this.type, this.index,this.task, this.tasks});
  Actions type;
  Task task;
  List<Task> tasks;
  int index;
}

class TasksState {
  TasksState({this.tasks, this.isLoading});
  List<Task> tasks;
  bool isLoading;

  TasksState merge(TasksState newState) {
    if(newState.tasks != null) {
      tasks = newState.tasks;
    }
    if(newState.isLoading != null) {
      isLoading = newState.isLoading;
    }
    return this;
  }
}

populateTasks(List<Task> tasks) {
  return new TaskAction(
    type: Actions.PopulateTasks,
    tasks: tasks
  );
}

addTask(Task task) {
  return new TaskAction(
    type: Actions.AddTask,
    task: task
  );
}

replaceTask(int index, Task task) {
  return new TaskAction(
    type: Actions.ReplaceTask,
    index: index,
    task: task
  );
}

startLoading() {
  return new TaskAction(
    type: Actions.StartLoading
  );
}

stopLoading() {
  return new TaskAction(
    type: Actions.StopLoading
  );
}
