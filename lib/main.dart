import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/features/todo/data/repositories/task_repository_impl.dart';
import 'features/todo/presentation/controllers/task_controller.dart';

import 'features/todo/data/datasources/task_local_datasource.dart';
import 'features/todo/presentation/screens/task_list_screen.dart';

void main() {
  final localDatasource = TaskLocalDatasource();
  final repository = TaskRepositoryImpl(localDatasource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskController(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskListScreen(),
    );
  }
}
