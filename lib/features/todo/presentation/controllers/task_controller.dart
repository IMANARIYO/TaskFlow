import 'package:flutter/material.dart';
import 'package:task_flow/features/todo/data/repositories/task_repository.dart';
import '../../domain/entities/task.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository repository;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _initialized = false;

  TaskController(this.repository);

  // Called once when screen starts
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await repository.seedIfEmpty(_initialTasks());
    _tasks = await repository.getTasks();
    notifyListeners();
  }

  // Load tasks ONLY (no seeding here)
  Future<void> loadTasks() async {
    _tasks = await repository.getTasks();
    notifyListeners();
  }

  // Create a new task
  Future<void> addTask(
      String title, String description, DateTime dueDate) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      status: TaskStatus.pending,
    );

    // Optimistic update
    _tasks.add(task);
    notifyListeners();

    await repository.createTask(task);
  }

  // Update existing task
  Future<void> updateTask(
    Task task, {
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
  }) async {
    final updatedTask = task.copyWith(
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
    );

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }

    await repository.updateTask(updatedTask);
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();

    await repository.deleteTask(id);
  }

  // Cycle status
  Future<void> toggleStatus(Task task) async {
    final nextStatus = switch (task.status) {
      TaskStatus.pending => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.completed,
      TaskStatus.completed => TaskStatus.pending,
    };

    await updateTask(task, status: nextStatus);
  }

  // Seed data (controller provides it, repository decides if needed)
  List<Task> _initialTasks() {
    final now = DateTime.now();

    return [
      Task(
        id: '1',
        title: 'Learn Flutter',
        description: 'Understand widgets, state, and navigation',
        createdAt: now,
        dueDate: now.add(const Duration(days: 2)),
        status: TaskStatus.pending,
      ),
      Task(
        id: '2',
        title: 'Build Todo App',
        description: 'Implement CRUD using Clean Architecture',
        createdAt: now,
        dueDate: now.add(const Duration(days: 4)),
        status: TaskStatus.inProgress,
      ),
      Task(
        id: '3',
        title: 'Polish UI',
        description: 'Use reusable widgets and Provider',
        createdAt: now,
        dueDate: now.add(const Duration(days: 6)),
        status: TaskStatus.completed,
      ),
    ];
  }
}
