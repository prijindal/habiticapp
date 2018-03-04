import '../actions/tasks.dart';

TasksState tasksReducer(TasksState state, TaskAction action) {
  if(action.type == Actions.AddTask) {
    state.tasks.add(action.task);
    return state;
  }
  if(action.type == Actions.PopulateTasks) {
    return state.merge(
      new TasksState(
        tasks: action.tasks
      )
    );
  }
  if(action.type == Actions.ReplaceTask) {
    state.tasks[action.index] = action.task;
  }
  if(action.type == Actions.StartLoading) {
    state.isLoading  = true;
  }
  if(action.type == Actions.StopLoading) {
    state.isLoading = false;
  }
  if(action.type == Actions.Clear) {
    return new TasksState();
  }
  return state;
}

