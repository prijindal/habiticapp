import 'dart:async';
import 'dart:collection';
import 'base.dart';

import '../models/user.dart';
import 'login.class.dart';

Future<User> getUser({LoginResponse loginInformation}) async {
  var url = "/user";
  Map<String, String> query = {};
  Map<String, dynamic> responseJson = await get(url, query, loginInformation);
  Map<String, dynamic> data = responseJson['data'];
  // for (var key in data.keys) {
  //   print(key + ": " + data[key].toString());
  // }
  User user = new User(LinkedHashMap.from(data));
  return user;
}
