import 'base.dart';
import 'provider.dart';

final String columnId = "id";
final String columnUserId = "userId";
final String columnText = "text";
final String columnType = "type";
final String columnUp = "up";
final String columnDown = "down";
final String columnDate = "date";
final String columnCompleted = "completed";
final String columnCounterUp = "counterUp";
final String columnCounterDown = "counterDown";
final String columnStreak = "streak";

final List<String> columns = [
  columnId,
  columnUserId,
  columnText,
  columnType,
  columnUp,
  columnDown,
  columnDate,
  columnCompleted,
  columnCounterUp,
  columnCounterDown,
  columnStreak,
];

class Task extends BaseObject {
  @override
  Task(Map<String, dynamic> map):super(map) {
    id = getDefaultMap(map, columnId);
    userId = getDefaultMap(map, columnUserId);
    text = getDefaultMap(map, columnText);
    type = getDefaultMap(map, columnType);
    date = getDefaultMap(map, columnDate);

    up = getDefaultMap(map, columnUp, false);
    down = getDefaultMap(map, columnDown, false);
    completed = getDefaultMap(map, columnCompleted, false);
    counterUp = getDefaultMap(map, columnCounterUp, 0);
    counterDown = getDefaultMap(map, columnCounterDown, 0);
    streak = getDefaultMap(map, columnStreak, 0);
  }

  @override
  Map<String, dynamic> toMap() {
    Map map = {
      // columnId: id,      
      // columnUserId: userId,
      columnText: text,
      columnType: type,
    };
    map = checkNullAndAdd(map, columnDate, date);
    map = checkNullAndAdd(map, columnUp, up);
    map = checkNullAndAdd(map, columnDown, down);
    map = checkNullAndAdd(map, columnStreak, streak);
    return map;
  }

  String id;
  String userId;
  String text;
  String type;
  bool up;
  bool down;
  String date;
  bool completed;
  int counterDown;
  int counterUp;
  int streak;
}

class TaskProvider extends ListProvider<Task> {
  TaskProvider({String table}):super(table:table);

  @override
    Task newElement(object) {
      // TODO: implement newElement
      return new Task(object);
    }
  @override
    Map<String, dynamic> mapElement(Task object) {
      // TODO: implement mapElement
      return object.toMap();
    }
}
