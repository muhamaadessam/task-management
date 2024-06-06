import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:task/Core/Services/cache_helper.dart';
import 'package:task/Task/Data/Models/task_model.dart';

import '../../Task/Presentation/Controllers/task_bloc.dart';



class SyncService {
  final Box<TaskModel> taskBox = Hive.box<TaskModel>('tasks');
  Future<void> syncData(context) async {
    final tasks = taskBox.values.toList();
    print('syncData:: Start ${CacheHelper.get(key: 'connected')}');
    for (var task in tasks) {
      try {
        FirebaseFirestore.instance
            .collection('users').doc(CacheHelper.get(key: 'uId')).collection('tasks')
            .add(task.toJson()).then((value) async {

          await task.delete();
        }).then((value) {
          BlocProvider.of<TaskBloc>(context).add(LoadTasksFromRemote());
        }).catchError((error){
          print('error:: $error');
        });

      } catch (e) {
        // Handle error
      }
    }
  }
}
