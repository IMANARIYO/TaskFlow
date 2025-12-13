import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskLocalDatasource {
  static const _key = 'tasks';

  Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => TaskModel.fromMap(json.decode(e))).toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = tasks.map((t) => json.encode(t.toMap())).toList();
    await prefs.setStringList(_key, data);
  }
}
