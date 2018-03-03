class Task {
  Task(Map<String, dynamic> data) {
    _id = data['_id'];
    userId = data['userId'];
    text = data['text'];
  }

  String _id;
  String userId;
  String text;

  Map<String, dynamic> toMapped() {
    return {
      "_id": _id,
      "userId": userId,
      "text": text
    };
  }

  @override
    String toString() {
      return toMapped().toString();
    }
}
