import 'package:redux/redux.dart';

import 'reducers/tasks.dart';
import 'actions/tasks.dart';

import 'reducers/user.dart';
import 'actions/user.dart';

final Store<TasksState> tasksstore = new Store(tasksReducer, initialState: new TasksState(tasks: [], isLoading: true));

final Store<UserState> userstore = new Store(userReducer, initialState: new UserState(user: null, isLoading: true));
