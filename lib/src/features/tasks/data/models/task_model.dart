class TaskModel {
  final String id;
  final String title;
  final bool done;
  final int createdAt;
  final int? dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
    this.dueDate,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    bool? done,
    int? createdAt,
    int? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      done: json['done'],
      createdAt: json['createdAt'],
      dueDate: json['dueDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'done': done,
    'createdAt': createdAt,
    'dueDate': dueDate,
  };
}
