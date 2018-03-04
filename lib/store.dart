import 'package:redux/redux.dart';

import 'reducers/tasks.dart';
import 'actions/tasks.dart';

final store = new Store(tasksReducer, initialState: new TasksState(tasks: [], isLoading: true));
