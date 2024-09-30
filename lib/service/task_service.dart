import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/taskModel.dart';

class TaskService {
  Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      return savedTasks.map((task) => Task.fromMap(json.decode(task))).toList();
    }
    return [];
  }

  Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saveTasks =
        tasks.map((task) => json.encode(task.toMap())).toList();
    await prefs.setStringList('tasks', saveTasks);
  }
}
