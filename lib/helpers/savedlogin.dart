import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/login.class.dart';

Future<LoginResponse> getLoginInformation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('id');
  String apiToken = prefs.getString('apiToken');
  LoginResponse loginInformation = new LoginResponse(id, apiToken);
  return loginInformation;
}
