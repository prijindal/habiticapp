import 'dart:collection';
import 'base.dart';

class Tag extends BaseObject {
  String id;  
  String name;
  @override

  Tag(LinkedHashMap map):super(map) {
    id = getDefaultMap(map, "id");
    name = getDefaultMap(map, "name");
  }

  @override
    LinkedHashMap toMap() {
      // TODO: implement toMap
      Map map = {
        "name": name,
        "id": id
      };
      return map;
    }
}
