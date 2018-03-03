import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'login.class.dart';

const String HOST = "habitica.com";
const String API_PATH = "/api/v3";
const String API_URL = HOST + API_PATH;

Uri uriBuilder(String url, [Map<String, dynamic> query]) {
  return new Uri(host: HOST, path: API_PATH + url, queryParameters: query, scheme: "https");
}

post(String url, Map<String, dynamic> body, [String apiToken]) async {
  var httpClient = new http.Client();
  Uri uri = uriBuilder(url);
  var request = new http.Request('POST', uri);
  request.bodyFields = body;
  var responseStream = await httpClient.send(request);
  return responseStream;
}

Future<Map<String, dynamic>> get(String url, [Map<String,String> query, LoginResponse loginInformation]) async {
  var httpClient = new http.Client();
  Map<String, String> headers = {};
  Uri uri = uriBuilder(url, query);
  if(loginInformation != null) {
    headers['x-api-key'] = loginInformation.apiToken;
    headers['x-api-user'] = loginInformation.id;
  }
  var responseStream = await httpClient.get(uri, headers: headers);
  String response = responseStream.body;
  var responseJson = JSON.decode(response);
  if (responseStream.statusCode == HttpStatus.OK) {
    return responseJson;
  } else {
    throw new Exception(responseJson['error']);    
  }
}

streamToJson(http.StreamedResponse responseStream) async {
  var response = await responseStream.stream.bytesToString();
  var json = response.toString();
  var responseJson = JSON.decode(json);
  return responseJson;
}
