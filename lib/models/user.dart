import 'base.dart';
import 'provider.dart';

class Local extends BaseObject{
  String email;
  Local(Map<String,dynamic> map):super(map) {
    email = getDefaultMap(map, "email");
  }

  @override
    Map<String, dynamic> toMap() {
      return {
        "email": email
      };
    }
}

class UserAuth extends BaseObject{
  Local local;
  UserAuth(Map<String, dynamic> map):super(map) {
    local = new Local(getDefaultMap(map, "local"));
  }

  @override
    Map<String, dynamic> toMap() {
      // TODO: implement toMap
      return {
        "local": local.toMap()
      };
    }
}

class UserProfile extends BaseObject {
  String name;
  String imageUrl;

  UserProfile(Map<String, dynamic> map):super(map) {
    name = getDefaultMap(map, "name");
    imageUrl = getDefaultMap(map, "imageUrl");
  }
  @override
    Map<String, dynamic> toMap() {
      // TODO: implement toMap
      return {
        "name": name,
        "imageUrl": imageUrl
      };
    }
}

class User extends BaseObject{
  UserAuth auth;
  UserProfile profile;
  String id;

  User(Map<String,dynamic> map):super(map) {
    auth = new UserAuth(getDefaultMap(map, "auth"));
    profile = new UserProfile(getDefaultMap(map, "profile"));
    id = getDefaultMap(map, "id");
  }

  @override
    Map<String, dynamic> toMap() {
      Map map = {
        "auth": auth.toMap(),
        "profile": profile.toMap(),
        "id": id
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
    Map<String, dynamic> mapElement(User object) {
      // TODO: implement mapElement
      return object.toMap();
    }
}
