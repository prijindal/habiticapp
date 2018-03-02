import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'login.class.dart';

login(String username, String password) async {
  var url = "https://habitica.com/api/v3/user/auth/local/login";
  var httpClient = new http.Client();
  String result;
  var request = new http.Request('POST', Uri.parse(url));
  var body = {'username': username, 'password': password};
  request.bodyFields = body;
  var responseStream = await httpClient.send(request);
  var response = await responseStream.stream.bytesToString();
  var json = response.toString();
  var responseJson = JSON.decode(json);
  if (responseStream.statusCode == HttpStatus.OK) {
    var data = responseJson['data'];
    print(data);
    LoginResponse responseData = new LoginResponse(data['id'], data['apiToken']);
    return responseData;
  } else {
    throw new Exception(responseJson['error']);
  }
}
