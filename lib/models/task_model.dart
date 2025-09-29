import 'package:flutter/material.dart';

class TaskItemModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String priority; // 'low', 'medium', 'high'

  TaskItemModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = 'medium',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'priority': priority,
    };
  }

  factory TaskItemModel.fromMap(Map<String, dynamic> map) {
    return TaskItemModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Personal',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
      priority: map['priority'] ?? 'medium',
    );
  }

  TaskItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
  }) {
    return TaskItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }

  Color get priorityColor {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
