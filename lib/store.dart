import 'package:redux/redux.dart';

import 'reducers/tasks.dart';
import 'actions/tasks.dart';

import 'reducers/user.dart';
import 'actions/user.dart';

final Store<TasksState> tasksstore = new Store(
  (TasksState state, dynamic action) => tasksReducer(state, action as TaskAction),
  initialState: new TasksState(tasks: [], isLoading: true)
);

final Store<UserState> userstore = new Store(
  (UserState state, dynamic action) => userReducer(state, action as UserAction),
  initialState: new UserState(user: null, isLoading: true)
);
