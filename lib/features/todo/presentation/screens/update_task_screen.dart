import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_form.dart';
import '../../domain/entities/task.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TaskForm(
          initialTitle: task.title,
          initialDescription: task.description,
          initialDueDate: task.dueDate,
          onSubmit: (title, description, dueDate) {
            context.read<TaskController>().updateTask(
                  task,
                  title: title,
                  description: description,
                  dueDate: dueDate,
                );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
