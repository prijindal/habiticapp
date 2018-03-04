import '../models/task.dart';

import 'base.dart';

enum Actions {
  AddTask,
  PopulateTasks,
  ReplaceTask,
  StartLoading,
  StopLoading,
  Clear
}


class TaskAction extends Action {
  TaskAction({this.type, this.index,this.task, this.tasks});
  Actions type;
  Task task;
  List<Task> tasks;
  int index;
    
  static TaskAction populateTasks(List<Task> tasks) {
    return new TaskAction(
      type: Actions.PopulateTasks,
      tasks: tasks
    );
  }

  static TaskAction addTask(Task task) {
    return new TaskAction(
      type: Actions.AddTask,
      task: task
    );
  }

  static TaskAction replaceTask(int index, Task task) {
    return new TaskAction(
      type: Actions.ReplaceTask,
      index: index,
      task: task
    );
  }

  static TaskAction startLoading() {
    return new TaskAction(
      type: Actions.StartLoading
    );
  }

  static TaskAction stopLoading() {
    return new TaskAction(
      type: Actions.StopLoading
    );
  }

  static TaskAction clear() {
    return new TaskAction(
      type: Actions.Clear
    );
  }
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
