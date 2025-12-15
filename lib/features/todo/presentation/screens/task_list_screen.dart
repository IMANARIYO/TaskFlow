import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/features/todo/presentation/screens/create_task_screen.dart';
import 'package:task_flow/features/todo/presentation/screens/update_task_screen.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_tile.dart';
import '../../domain/entities/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();

    // Run after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().initialize();
    });
  }

  void _navigateToCreateTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
    );
  }

  void _navigateToEditTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: Consumer<TaskController>(
        builder: (context, controller, _) {
          if (controller.tasks.isEmpty) {
            return const Center(child: Text('No tasks yet'));
          }
          return ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return TaskTile(
                task: task,
                onTap: () => _navigateToEditTask(task),
                onToggleStatus: () => controller.toggleStatus(task),
                onDelete: () => controller.deleteTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
