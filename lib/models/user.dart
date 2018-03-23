import 'dart:collection';
import 'base.dart';
import 'provider.dart';
import 'tag.dart';

class Local extends BaseObject{
  String email;
  Local(LinkedHashMap map):super(map) {
    email = getDefaultMap(map, "email");
  }

  @override
    LinkedHashMap toMap() {
      Map map = {
        "email": email
      };
      return map;
    }
}

class UserAuth extends BaseObject{
  Local local;
  UserAuth(LinkedHashMap map):super(map) {
    local = new Local(getDefaultMap(map, "local"));
  }

  @override
    LinkedHashMap toMap() {
      // TODO: implement toMap
      Map map = {
        "local": local.toMap()
      };
      return map;
    }
}

class UserProfile extends BaseObject {
  String name;
  String imageUrl;

  UserProfile(LinkedHashMap map):super(map) {
    name = getDefaultMap(map, "name");
    imageUrl = getDefaultMap(map, "imageUrl");
  }
  @override
    LinkedHashMap toMap() {
      // TODO: implement toMap
      Map map = {
        "name": name,
        "imageUrl": imageUrl
      };
      return map;
    }
}

class TasksOrder extends BaseObject {
  List<String> habits;
  List<String> dailys;
  List<String> todos;
  List<String> rewards;

  TasksOrder(LinkedHashMap map):super(map) {
    habits = getDefaultMap(map, "habits", []).cast<String>();
    dailys = getDefaultMap(map, "dailys", []).cast<String>();
    todos = getDefaultMap(map, "todos", []).cast<String>();
    rewards = getDefaultMap(map, "rewards", []).cast<String>();
  }

  LinkedHashMap toMap() {
    Map map = {};
    map = checkNullAndAdd(map, "habits", habits);
    map = checkNullAndAdd(map, "dailys", dailys);
    map = checkNullAndAdd(map, "todos", todos);
    map = checkNullAndAdd(map, "rewards", rewards);
    return map;
  }
}

class User extends BaseObject{
  UserAuth auth;
  UserProfile profile;
  String id;
  List<Tag> tags;
  TasksOrder tasksOrder;

  User(LinkedHashMap map):super(map) {
    auth = new UserAuth(getDefaultMap(map, "auth"));
    profile = new UserProfile(getDefaultMap(map, "profile"));
    tasksOrder = new TasksOrder(getDefaultMap(map, "tasksOrder", {}));
    id = getDefaultMap(map, "id");
    tags = getDefaultMap(map, "tags", []).map((tag) => new Tag(tag)).cast<Tag>().toList();
  }

  @override
    LinkedHashMap toMap() {
      Map map = {
        "auth": auth.toMap(),
        "profile": profile.toMap(),
        "tasksOrder": tasksOrder.toMap(),
        "id": id,
        "tags": tags.map((tag) => tag.toMap()).toList()
      };
      // TODO: implement toMap
      return map;
    }
}

class UserProvider extends ObjectProvider<User> {
  UserProvider({String table}):super(table:table);

  @override
    User newElement(object) {
      // TODO: implement newElement
      return new User(object);
    }
  @override
    LinkedHashMap mapElement(User object) {
      // TODO: implement mapElement
      return object.toMap();
    }
}
