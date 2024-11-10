class TodoModel {
  int? id;
  String title;
  String description;
  int priority = 1;
  bool completed;
  DateTime createdAt;

  TodoModel(
      {this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.completed,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'completed': completed ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id']?.toInt(),
      title: map['title'],
      description: map['description'],
      priority: map['priority']?.toInt() ?? 1,
      completed: (map['completed'] ?? 0) == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
