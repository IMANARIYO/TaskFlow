import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_form.dart';

class CreateTaskScreen extends StatelessWidget {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TaskForm(
          onSubmit: (title, description, dueDate) {
            context.read<TaskController>().addTask(title, description, dueDate);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
