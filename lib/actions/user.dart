import '../models/user.dart';
import 'base.dart';

enum Actions {
  PopulateUser,
  StartLoading,
  StopLoading,
  Clear
}

class UserAction extends Action {
  UserAction({this.type,this.user});
  Actions type;
  User user;
  
  static UserAction populateUser(User user) {
    return new UserAction(
      user: user,
      type: Actions.PopulateUser
    );
  }
  
  static UserAction startLoading() {
    return new UserAction(
      type: Actions.StartLoading
    );
  }

  static UserAction stopLoading() {
    return new UserAction(
      type: Actions.StopLoading
    );
  }

  static UserAction clear() {
    return new UserAction(
      type: Actions.Clear
    );
  }
}

class UserState {
  UserState({this.user, this.isLoading});
  User user;
  bool isLoading;
  
  UserState merge(UserState newUser) {
    if(newUser.user != null) {
      user = newUser.user;
    }
    if(newUser.isLoading != null) {
      isLoading = newUser.isLoading;
    }
    return this;
  }
}
