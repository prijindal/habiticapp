import 'package:uuid/uuid.dart';

import '../api/user.dart';
import '../helpers/savedlogin.dart';

import '../models/user.dart';
import '../actions/user.dart';
import '../store.dart';

import 'base.dart';

final _userProvider = new UserProvider(table: "user");
final uuid = new Uuid();

getOfflineUser() async {
  await getOfflineObjects(_userProvider, userstore, (objects) => UserAction.populateUser(objects));
}

getNetworkUser() async {
  try {
    userstore.dispatch(UserAction.startLoading());
    var loginInformation = await getLoginInformation();
    User data = await getUser(loginInformation: loginInformation);
    if(data == null) {
      return;
    }
    userstore.dispatch(UserAction.populateUser(data));
    userstore.dispatch(UserAction.stopLoading());
    syncUser(data);
  } catch(e) {
    print(e);
  }
}

syncUser(user) async {
  syncObject(_userProvider, user);
}

clearUser() {
  userstore.dispatch(UserAction.clear());
}
