import '../actions/user.dart';

UserState userReducer(UserState state, UserAction action) {
  if(action.type == Actions.PopulateUser) {
    return state.merge(new UserState(user: action.user));
  }
  if(action.type == Actions.StartLoading) {
    state.isLoading  = true;
  }
  if(action.type == Actions.StopLoading) {
    state.isLoading = false;
  }
  if(action.type == Actions.Clear) {
    return new UserState();
  }
  return state;
}
