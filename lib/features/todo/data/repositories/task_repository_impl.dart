import 'package:flutter/material.dart';
import 'package:task_flow/features/todo/data/repositories/task_repository.dart';

import '../../domain/entities/task.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDatasource localDatasource;

  TaskRepositoryImpl(this.localDatasource);

  @override
  @override
  Future<List<Task>> getTasks() async {
    final models = await localDatasource.getTasks();

    // debug prints
    debugPrint('[Repository] Loaded ${models.length} tasks from local storage');

    // Convert models → entities
    final tasks = models.map((m) => m.toEntity()).toList();

    for (var t in tasks) {
      debugPrint('- ${t.id}: ${t.title} [${t.status}] due ${t.dueDate}');
    }

    return tasks; // ✅ now returning List<Task>
  }

  @override
  Future<void> createTask(Task task) async {
    debugPrint('════════════════════════════════════');
    debugPrint('📌 TaskRepository.createTask');
    debugPrint('────────────────────────────────────');
    debugPrint('• Incoming task');
    debugPrint('  - id     : ${task.id}');
    debugPrint('  - title  : ${task.title}');
    debugPrint('  - status : ${task.status.name}');
    debugPrint('────────────────────────────────────');

    final models = await localDatasource.getTasks();

    debugPrint('• Tasks before add : ${models.length}');

    // Convert entity → model before saving
    final model = TaskModel.fromEntity(task);
    models.add(model);

    debugPrint('• Tasks after add  : ${models.length}');
    debugPrint('• Saving tasks to local storage…');

    await localDatasource.saveTasks(models);

    debugPrint('✅ createTask completed');
    debugPrint('════════════════════════════════════');
  }

  @override
  Future<void> updateTask(Task task) async {
    debugPrint('════════════════════════════════════');
    debugPrint('📌 TaskRepository.updateTask');
    debugPrint('────────────────────────────────────');
    debugPrint('• Incoming task');
    debugPrint('  - id     : ${task.id}');
    debugPrint('  - title  : ${task.title}');
    debugPrint('  - status : ${task.status.name}');
    debugPrint('────────────────────────────────────');

    final models = await localDatasource.getTasks();
    final index = models.indexWhere((t) => t.id == task.id);

    if (index == -1) {
      debugPrint('⚠️ Task with id ${task.id} not found');
      return;
    }

    // Convert entity → model before saving
    models[index] = TaskModel.fromEntity(task);

    debugPrint('• Saving updated task to local storage…');
    await localDatasource.saveTasks(models);

    debugPrint('✅ updateTask completed');
    debugPrint('════════════════════════════════════');
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
