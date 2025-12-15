import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
    this.onDelete,
    this.onToggleStatus,
  });

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return "Pending";
      case TaskStatus.inProgress:
        return "In Progress";
      case TaskStatus.completed:
        return "Completed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          Icons.task_alt,
          color: _getStatusColor(task.status),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('ID: ${task.id}'),
            Text('Description: ${task.description}'),
            Text(
                'Created: ${task.createdAt.toLocal().toString().split('.')[0]}'),
            Text('Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            GestureDetector(
              onTap: onToggleStatus,
              child: Chip(
                label: Text(_getStatusText(task.status)),
                backgroundColor: _getStatusColor(task.status).withOpacity(0.2),
                labelStyle: TextStyle(color: _getStatusColor(task.status)),
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
