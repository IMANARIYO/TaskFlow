import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final DateTime? initialDueDate;
  final void Function(String title, String description, DateTime dueDate)
      onSubmit;

  const TaskForm({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.initialDueDate,
    required this.onSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
    _dueDate = widget.initialDueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _dueDate != null) {
      widget.onSubmit(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _dueDate!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter a title' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter a description' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(_dueDate == null
                    ? 'Select Due Date'
                    : 'Due: ${_dueDate!.toLocal()}'.split(' ')[1]),
              ),
              TextButton(
                onPressed: _pickDueDate,
                child: const Text('Pick Date'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
