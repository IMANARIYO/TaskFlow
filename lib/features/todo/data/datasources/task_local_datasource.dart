import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskLocalDatasource {
  static const _key = 'tasks';

  Future<List<TaskModel>> getTasks() async {
    debugPrint('\n════════════════════════════════════');
    debugPrint('📂 TaskLocalDatasource.getTasks');
    debugPrint('────────────────────────────────────');

    debugPrint('• Obtaining SharedPreferences instance…');
    final prefs = await SharedPreferences.getInstance();

    debugPrint('• Reading key "$_key" from local storage');
    final raw = prefs.getStringList(_key) ?? [];

    debugPrint('• Raw records found : ${raw.length}');

    if (raw.isEmpty) {
      debugPrint('⚠️ No tasks stored locally');
    } else {
      debugPrint('• Decoding stored tasks:');
    }

    final tasks = <TaskModel>[];

    for (var i = 0; i < raw.length; i++) {
      debugPrint('  ├─ Record ${i + 1}');
      debugPrint('  │  JSON → ${raw[i]}');

      final map = json.decode(raw[i]);
      final task = TaskModel.fromMap(map);

      debugPrint(
        '  │  Parsed → '
        'id=${task.id}, '
        'title="${task.title}", '
        'status=${task.status.name}',
      );

      tasks.add(task);
    }

    debugPrint('────────────────────────────────────');
    debugPrint('✅ getTasks completed → ${tasks.length} task(s)');
    debugPrint('════════════════════════════════════\n');

    return tasks;
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    debugPrint('\n════════════════════════════════════');
    debugPrint('💾 TaskLocalDatasource.saveTasks');
    debugPrint('────────────────────────────────────');

    debugPrint('• Obtaining SharedPreferences instance…');
    final prefs = await SharedPreferences.getInstance();

    debugPrint('• Preparing ${tasks.length} task(s) for storage');

    final data = <String>[];

    for (var i = 0; i < tasks.length; i++) {
      final jsonString = json.encode(tasks[i].toMap());

      debugPrint(
        '  ├─ Task ${i + 1} → '
        'id=${tasks[i].id}, '
        'title="${tasks[i].title}", '
        'status=${tasks[i].status.name}',
      );
      debugPrint('  │  JSON → $jsonString');

      data.add(jsonString);
    }

    debugPrint('• Writing data to key "$_key"');
    await prefs.setStringList(_key, data);

    debugPrint('────────────────────────────────────');
    debugPrint('✅ saveTasks completed');
    debugPrint('════════════════════════════════════\n');
  }
}
