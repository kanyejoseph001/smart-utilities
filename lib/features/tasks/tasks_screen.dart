import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Box<Task> taskBox;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  void _addOrEditTask({Task? existingTask}) {
    final titleController = TextEditingController(text: existingTask?.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingTask == null ? 'New Task' : 'Edit Task'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Task title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final trimmed = titleController.text.trim();
              if (trimmed.isEmpty) return;

              if (existingTask == null) {
                // Create new
                final newTask = Task(
                  id: _uuid.v4(),
                  title: trimmed,
                  createdAt: DateTime.now(),
                );
                taskBox.put(newTask.id, newTask);
              } else {
                // Edit existing
                existingTask.title = trimmed;
                taskBox.put(existingTask.id, existingTask);
              }

              Navigator.pop(context);
              setState(() {});
            },
            child: Text(existingTask == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks & Checklist')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet.\nTap + to add one!',
                textAlign: TextAlign.center,
              ),
            );
          }

          final tasks = box.values.toList()
            ..sort((a, b) => a.isCompleted == b.isCompleted
                ? b.createdAt.compareTo(a.createdAt)
                : a.isCompleted ? 1 : -1);

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: CheckboxListTile(
                  value: task.isCompleted,
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Text(
                    'Created: ${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onChanged: (value) {
                    task.isCompleted = value!;
                    taskBox.put(task.id, task);
                  },
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _addOrEditTask(existingTask: task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Task?'),
                              content: const Text('This cannot be undone.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    taskBox.delete(task.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}