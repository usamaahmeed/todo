import 'package:flutter/material.dart';

import '../models/taskModel.dart';
import '../service/task_service.dart';
import 'addTaskScreen.dart';
import 'edit_task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  TaskService taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await taskService.loadTasks();
    setState(() {});
  }

  Future<void> _saveTasks() async {
    await taskService.saveTasks(tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      _saveTasks();
    });
  }

  void _navigateToAddTask() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
        _saveTasks();
      });
    }
  }

  void _navigateToEditTask(int index) async {
    final editedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: tasks[index]),
      ),
    );
    if (editedTask != null) {
      setState(() {
        tasks[index] = editedTask;
        _saveTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks available'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].title),
                  subtitle: Text(tasks[index].description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTask(index),
                  ),
                  leading: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (value) => _toggleTaskCompletion(index),
                  ),
                  onTap: () => _navigateToEditTask(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
