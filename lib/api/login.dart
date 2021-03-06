import 'dart:io';

import 'base.dart';

import 'login.class.dart';

login(String username, String password) async {
  var url = "/user/auth/local/login";
  var body = {'username': username, 'password': password};
  var responseStream = await loginPost(url, body);
  var responseJson = await streamToJson(responseStream);
  if (responseStream.statusCode == HttpStatus.ok) {
    var data = responseJson['data'];
    LoginResponse responseData =
        new LoginResponse(data['id'], data['apiToken']);
    return responseData;
  } else {
    throw new Exception(responseJson['error']);
  }
}
