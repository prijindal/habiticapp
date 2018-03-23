import 'dart:convert';
import 'dart:collection';
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

loginPost(String url, Map<String, dynamic> body, [String apiToken]) async {
  var httpClient = new http.Client();
  Uri uri = uriBuilder(url);
  var request = new http.Request('POST', uri);
  request.bodyFields = body;
  var responseStream = await httpClient.send(request);
  return responseStream;
}

Map<String, String> getHeaders([LoginResponse loginInformation]) {
  Map<String, String> headers = {};
  if(loginInformation != null) {
    headers['x-api-key'] = loginInformation.apiToken;
    headers['x-api-user'] = loginInformation.id;
  }
  return headers;
}

Future<Map<String, dynamic>> get(String url, [Map<String,String> query, LoginResponse loginInformation]) async {
  print(url);
  var httpClient = new http.Client();
  var headers = getHeaders(loginInformation);
  headers['content-type'] = "application/json";
  Uri uri = uriBuilder(url, query);
  http.Request request = new http.Request("GET", uri);
  request.headers.addAll(headers);
  var responseStream = await httpClient.send(request);
  return await postProcess(responseStream);
}

Future<Map<String, dynamic>> dataRequest(String url, String method, LinkedHashMap body, [Map<String,String> query, LoginResponse loginInformation]) async {
  var httpClient = new http.Client();
  var headers = getHeaders(loginInformation);
  headers['content-type'] = "application/json";  
  Uri uri = uriBuilder(url, query);
  http.Request request = new http.Request(method, uri);
  request.body = const JsonEncoder().convert(body.cast<String, dynamic>());
  request.headers.addAll(headers);
  var responseStream = await httpClient.send(request);
  return await postProcess(responseStream);
}

Future<Map<String, dynamic>> post(String url, LinkedHashMap body, [Map<String,String> query, LoginResponse loginInformation]) async {
  return await dataRequest(url, "POST", body, query, loginInformation);
}

Future<Map<String, dynamic>> put(String url, LinkedHashMap body, [Map<String,String> query, LoginResponse loginInformation]) async {
  return await dataRequest(url, "PUT", body, query, loginInformation);
}


postProcess(http.StreamedResponse responseStream) async {
  String response = await responseStream.stream.bytesToString();
  var responseJson = const JsonDecoder().convert(response);
  if (
    responseStream.statusCode == HttpStatus.ACCEPTED ||
    responseStream.statusCode == HttpStatus.CREATED || 
    responseStream.statusCode == HttpStatus.OK
  ) {
    return responseJson;
  } else {
    throw new Exception(responseJson);
  }
}

streamToJson(http.StreamedResponse responseStream) async {
  var response = await responseStream.stream.bytesToString();
  var json = response.toString();
  var responseJson = const JsonDecoder().convert(json);
  return responseJson;
}
