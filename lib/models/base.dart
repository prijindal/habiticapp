import 'dart:collection';

abstract class BaseObject {
  dynamic getDefaultMap(LinkedHashMap map, String column, [dynamic defaultValue]) {
    if(map.containsKey(column)) {
      return map[column];
    } else {
      return defaultValue;
    }
  }

  dynamic checkNullAndAdd(LinkedHashMap map, String key, dynamic value) {
    if (value != null) {
      map[key] = value;
    }
    return map;
  }

  @override
    String toString() {
      return toMap().toString();
    }
  toJson() {
    return toMap();
  }
  BaseObject(LinkedHashMap map);
  LinkedHashMap toMap();
}
