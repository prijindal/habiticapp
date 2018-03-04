abstract class BaseObject {
  dynamic getDefaultMap(Map<String, dynamic> map, String column, [dynamic defaultValue]) {
    if(map.containsKey(column)) {
      return map[column];
    } else {
      return defaultValue;
    }
  }

  dynamic checkNullAndAdd(Map<String, dynamic> map, String key, dynamic value) {
    if (value != null) {
      map[key] = value;
    }
    return map;
  }

  @override
    String toString() {
      return toMap().toString();
    }
  
  BaseObject(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
}
