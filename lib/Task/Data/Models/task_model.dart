import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  DateTime? dueDate;

  @HiveField(2)
  bool? isCompleted;
  @HiveField(3)
  String? id;

  TaskModel({
    this.id,
    required this.title,
    required this.dueDate,
    required this.isCompleted,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    dueDate = (json['dueDate'] is Timestamp)
        ? (json['dueDate'] as Timestamp).toDate()
        : json['dueDate'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['dueDate'] = dueDate;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
