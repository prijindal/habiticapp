import 'dart:async';
import 'base.dart';

import '../models/user.dart';
import 'login.class.dart';

Future<User> getUser({LoginResponse loginInformation}) async {
  var url = "/user";
  var query = {};
  Map<String, dynamic> responseJson = await get(url, query, loginInformation);
  Map<String, dynamic> data = responseJson['data'];
  User user = new User(data);
  return user;
}
