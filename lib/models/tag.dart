import 'base.dart';

class Tag extends BaseObject {
  String id;  
  String name;
  @override

  Tag(Map<String, dynamic> map):super(map) {
    id = getDefaultMap(map, "id");
    name = getDefaultMap(map, "name");
  }

  @override
    Map<String, dynamic> toMap() {
      // TODO: implement toMap
      Map map = {
        "name": name,
        "id": id
      };
      return map;
    }
}
