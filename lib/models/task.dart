import 'base.dart';
import 'provider.dart';

final String columnId = "id";
final String columnUserId = "userId";
final String columnText = "text";
final String columnType = "type";
final String columnUp = "up";
final String columnDown = "down";
final String columnDate = "date";
final String columnnotes = "notes";
final String columnCompleted = "completed";
final String columnCounterUp = "counterUp";
final String columnCounterDown = "counterDown";
final String columnStreak = "streak";
final String columnPriority = "priority";

enum Difficulty {
  Trivial,
  Easy,
  Medium,
  Hard
}

Map<Difficulty, double> diffToPriority = {
  Difficulty.Trivial: 0.1,
  Difficulty.Easy: 1.0,
  Difficulty.Medium: 1.5,
  Difficulty.Hard: 2.0
};

Difficulty priorityToDiff(double priority) {
  for (var key in Difficulty.values) {
    if (diffToPriority.containsKey(key)) {
      if(diffToPriority[key] == priority) {
        return key;
      }
    }
  }
  return Difficulty.Trivial;
}

class Task extends BaseObject {
  @override
  Task(Map<String, dynamic> map):super(map) {
    id = getDefaultMap(map, columnId);
    userId = getDefaultMap(map, columnUserId);
    text = getDefaultMap(map, columnText);
    type = getDefaultMap(map, columnType);
    date = getDefaultMap(map, columnDate);

    notes = getDefaultMap(map, columnnotes);
    difficulty = priorityToDiff(getDefaultMap(map, columnPriority));

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
      columnId: id,
      columnUserId: userId,
      columnText: text,
      columnType: type,
    };
    map = checkNullAndAdd(map, columnPriority, diffToPriority[difficulty]);
    map = checkNullAndAdd(map, columnnotes, notes);
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
  String notes;
  bool up;
  bool down;
  String date;
  bool completed;
  int counterDown;
  int counterUp;
  int streak;
  Difficulty difficulty;
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
