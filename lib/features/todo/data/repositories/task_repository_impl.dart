import 'package:task_flow/features/todo/data/repositories/task_repository.dart';

import '../../domain/entities/task.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDatasource localDatasource;

  TaskRepositoryImpl(this.localDatasource);

  @override
  Future<List<Task>> getTasks() async {
    final models = await localDatasource.getTasks();
    print('Loaded tasks from local storage:');
    for (var task in models) {
      print('- ${task.id}: ${task.title} [${task.status}] due ${task.dueDate}');
    }
    return models; // TaskModel extends Task
  }

  @override
  Future<void> createTask(Task task) async {
    final tasks = await localDatasource.getTasks();
    tasks.add(_toModel(task));
    await localDatasource.saveTasks(tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await localDatasource.getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return;
    tasks[index] = _toModel(task);
    await localDatasource.saveTasks(tasks);
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await localDatasource.getTasks();
    tasks.removeWhere((t) => t.id == id);
    await localDatasource.saveTasks(tasks);
  }

  @override
  Future<void> seedIfEmpty(List<Task> seedData) async {
    final tasks = await localDatasource.getTasks();
    if (tasks.isEmpty) {
      // Add seed data if the database is empty
      final seedModels = seedData.map((task) => _toModel(task)).toList();
      await localDatasource.saveTasks(seedModels);
    }
  }

  TaskModel _toModel(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      status: task.status, // updated to TaskStatus
    );
  }
}
