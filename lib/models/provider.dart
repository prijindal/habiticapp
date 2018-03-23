import 'dart:convert';
import 'dart:collection';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Provider<T> {
  SharedPreferences prefs;
  final String table;

  Provider({this.table});

  Future open() async {
    prefs = await SharedPreferences.getInstance();
    return;
  }

  T newElement(dynamic object);

  LinkedHashMap mapElement(T object);

  Future<bool> close() => prefs.commit();

  Future<dynamic> getTasks();

  Future<void> sync([dynamic a]);
}

abstract class ListProvider<T> extends Provider<T> {
  ListProvider({String table}):super(table:table);

  @override
  Future<List<T>> getTasks() async {
    String maps = prefs.getString(table);
    if(maps == null) {return null;}
    List<dynamic> objectList = const JsonDecoder().convert(maps);
    return objectList.map((object) => newElement(object)).toList();
  }

  @override
  Future<void> sync([dynamic objectList]) async {
    prefs.setString(table, const JsonEncoder().convert(objectList.map((object) => mapElement(object)).toList()));
  }
}

abstract class ObjectProvider<T> extends Provider<T> {
  ObjectProvider({String table}):super(table:table);
  @override
  Future<T> getTasks() async {
    String maps = prefs.getString(table);
    if(maps == null) {return null;}
    dynamic object = const JsonDecoder().convert(maps);
    return newElement(object);
  }

  @override
  Future<void> sync([dynamic object]) async {
    // T obj = (T) object;
    prefs.setString(table, const JsonEncoder().convert(mapElement(object as T)));
  }
}
