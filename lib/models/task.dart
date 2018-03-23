import 'base.dart';
import 'provider.dart';
import 'dart:collection';

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
final String columnTags = "tags";
final String columnCheckList = "checklist";
final String columnReminders = "reminders";

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

Map<Difficulty, String> diffToPrint = {
  Difficulty.Trivial: "Trivial",
  Difficulty.Easy: "Easy",
  Difficulty.Medium: "Medium",
  Difficulty.Hard: "Hard"
};

Difficulty priorityToDiff(dynamic priority) {
  for (var key in Difficulty.values) {
    if (diffToPriority.containsKey(key)) {
      if(diffToPriority[key] == priority) {
        return key;
      }
    }
  }
  return Difficulty.Trivial;
}

class TaskCheckListItem extends BaseObject {
  String id;
  String text;
  bool completed;

  @override
  TaskCheckListItem(LinkedHashMap map):super(map) {
    id = getDefaultMap(map, "id");
    text = getDefaultMap(map, "text");
    completed = getDefaultMap(map, "completed", false);
  }

  @override
    LinkedHashMap toMap() {
      // TODO: implement toMap
      Map map = {
        "id": id,
        "text": text,
        "completed": completed
      };
      return map;
    }
}

class TaskReminder extends BaseObject {
  String id;
  String startDate;
  String time;

  @override
  TaskReminder(LinkedHashMap map):super(map) {
    id = getDefaultMap(map, "id");
    startDate = getDefaultMap(map, "startDate");
    time = getDefaultMap(map, "time");
  }

  @override
    LinkedHashMap toMap() {
      // TODO: implement toMap
      Map map = {
        "id": id,
        "startDate": startDate,
        "time": time
      };
      return map;
    }
}

class Task extends BaseObject {
  @override
  Task(LinkedHashMap map):super(map) {
    id = getDefaultMap(map, columnId);
    userId = getDefaultMap(map, columnUserId);
    text = getDefaultMap(map, columnText);
    type = getDefaultMap(map, columnType);
    date = getDefaultMap(map, columnDate);

    notes = getDefaultMap(map, columnnotes);
    difficulty = priorityToDiff(getDefaultMap(map, columnPriority));
    tags = getDefaultMap(map, columnTags, []).cast<String>();
    checklist = getDefaultMap(map, columnCheckList, []).map((checkListItem) => new TaskCheckListItem(checkListItem)).cast<TaskCheckListItem>().toList();
    reminders = getDefaultMap(map, columnReminders, []).map((reminder) => new TaskReminder(reminder)).cast<TaskReminder>().toList();

    up = getDefaultMap(map, columnUp, false);
    down = getDefaultMap(map, columnDown, false);
    completed = getDefaultMap(map, columnCompleted, false);
    counterUp = getDefaultMap(map, columnCounterUp, 0);
    counterDown = getDefaultMap(map, columnCounterDown, 0);
    streak = getDefaultMap(map, columnStreak, 0);
  }

  @override
  LinkedHashMap toMap() {
    Map map = {
      columnId: id,
      columnUserId: userId,
      columnText: text,
      columnType: type,
    };
    map = checkNullAndAdd(map, columnReminders, reminders.map((f) => f.toMap()).toList());
    map = checkNullAndAdd(map, columnCheckList, checklist.map((f) => f.toMap()).toList());
    map = checkNullAndAdd(map, columnTags, tags);
    map = checkNullAndAdd(map, columnPriority, diffToPriority[difficulty]);
    map = checkNullAndAdd(map, columnnotes, notes);
    map = checkNullAndAdd(map, columnDate, date);
    map = checkNullAndAdd(map, columnUp, up);
    map = checkNullAndAdd(map, columnDown, down);
    map = checkNullAndAdd(map, columnCompleted, completed);
    map = checkNullAndAdd(map, columnCounterUp, counterUp);
    map = checkNullAndAdd(map, columnCounterDown, counterDown);
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
  List<String> tags;
  List<TaskCheckListItem> checklist;
  List<TaskReminder> reminders;
}

class TaskProvider extends ListProvider<Task> {
  TaskProvider({String table}):super(table:table);

  @override
    Task newElement(object) {
      // TODO: implement newElement
      return new Task(object);
    }
  @override
    LinkedHashMap mapElement(Task object) {
      // TODO: implement mapElement
      return object.toMap();
    }
}
