import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../Core/Services/cache_helper.dart';
import '../../Data/Models/task_model.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<TaskModel> taskBox;
  int currentIndex = 0;

  static TaskBloc get(context) => BlocProvider.of(context);

  TaskBloc(this.taskBox) : super(TaskLoading()) {
    on<LoadTasksFromLocal>(onLoadTasksFromLocal);
    on<LoadTasksFromRemote>(onLoadTasksFromRemote);
    on<ChangeTasksType>(onChangeTasksType);
    on<AddTask>(onAddTask);
    on<UpdateTask>(onUpdateTask);
    on<DeleteTask>(onDeleteTask);
  }

  void onLoadTasksFromLocal(LoadTasksFromLocal event, Emitter<TaskState> emit) {
    final List<TaskModel> tasks = taskBox.values.toList();
    emit(TaskLoaded(tasks));
  }

  Future<void> onLoadTasksFromRemote(
      LoadTasksFromRemote event, Emitter<TaskState> emit) async {
    List<TaskModel> tasks = [];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.get(key: 'uId'))
        .collection('tasks')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        print(element.data());
        tasks.add(TaskModel.fromJson(element.data()));
      }
    }).catchError((error) {
      print('error:: $error');
    });
    emit(TaskLoaded(tasks));
  }

  Future<void> onChangeTasksType(
      ChangeTasksType event, Emitter<TaskState> emit) async {
    List<TaskModel> tasks = [];
    currentIndex = event.currentIndex;
    if (CacheHelper.get(key: 'connected')) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.get(key: 'uId'))
          .collection('tasks')
          .get()
          .then((value) async {
        for (var element in value.docs) {
          TaskModel taskModel = TaskModel.fromJson(element.data());
          if (currentIndex == 0) {
            taskModel.id = element.id;
            tasks.add(taskModel);
          } else if (currentIndex == 1) {
            if (!taskModel.isCompleted!) {
              taskModel.id = element.id;
              tasks.add(taskModel);
            }
          } else if (currentIndex == 2) {
            if (taskModel.isCompleted!) {
              taskModel.id = element.id;
              tasks.add(taskModel);
            }
          }
        }
      }).catchError((error) {
        print('error:: $error');
      });
    } else {
      if (currentIndex == 0) {
        tasks = taskBox.values.toList();
      } else if (currentIndex == 1) {
        for (var task in taskBox.values.toList()) {
          if (!task.isCompleted!) tasks.add(task);
        }
      } else if (currentIndex == 2) {
        for (var task in taskBox.values.toList()) {
          if (task.isCompleted!) tasks.add(task);
        }
      }
    }
    emit(TaskLoaded(tasks));
  }

  Future<void> onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (CacheHelper.get(key: 'connected')) {
     await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.get(key: 'uId'))
          .collection('tasks')
          .add(event.task.toJson())
          .then((value) async {

       add(LoadTasksFromRemote());
      }).catchError((error) {
        print('error:: $error');
      });
    } else {
      taskBox.add(event.task);
      add(LoadTasksFromLocal());
    }
  }

  Future<void> onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    if (CacheHelper.get(key: 'connected')) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.get(key: 'uId'))
          .collection('tasks')
          .doc(event.task.id)
          .set(event.task.toJson())
          .then((value) async {
        add(LoadTasksFromRemote());
      }).catchError((error) {
        print('error:: $error');
      });
    } else {
      if (event.task.isInBox) {
        await event.task.save();
        add(LoadTasksFromLocal());
      }
    }
  }

  Future<void> onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (CacheHelper.get(key: 'connected')) {
      await  FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.get(key: 'uId'))
          .collection('tasks')
          .doc(event.task.id)
          .delete()
          .then((value) {
        add(LoadTasksFromRemote());
      }).catchError((error) {
        print('error:: $error');
      });
    } else {
      if (event.task.isInBox) {
        await event.task.delete();
        add(LoadTasksFromLocal());
      }
    }

  }
}
