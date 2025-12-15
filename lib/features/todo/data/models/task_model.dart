import 'package:task_flow/features/todo/domain/entities/task.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final TaskStatus status;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.status,
  });

  // Convert from Task entity
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      status: task.status,
    );
  }

  // Convert back to Task entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      dueDate: dueDate,
      status: status,
    );
  }

  // For JSON / storage
  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        createdAt: DateTime.parse(map['createdAt']),
        dueDate: DateTime.parse(map['dueDate']),
        status: TaskStatus.values.byName(map['status']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
        'status': status.name,
      };

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, status: $status, dueDate: $dueDate)';
  }
}
