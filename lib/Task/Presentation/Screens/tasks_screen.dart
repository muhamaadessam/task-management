import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task/Core/Components/custom_bottom_sheet.dart';
import 'package:task/Core/Services/cache_helper.dart';
import 'package:task/Core/Services/google_sign_in.dart';

import '../../../Core/Components/custom_Button.dart';
import '../../../Core/Services/connectivity_service.dart';
import '../../../Core/Services/sync_service.dart';
import '../../Data/Models/task_model.dart';
import '../Components/task_card.dart';
import '../Controllers/task_bloc.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final SyncService syncService = SyncService();
  final ConnectivityService connectivityService = ConnectivityService();
  final GoogleSignInService googleSignInService = GoogleSignInService();

  @override
  void initState() {
    super.initState();
    connectivityService.connectivityStream
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        CacheHelper.put(key: 'connected', value: true);
        await googleSignInService.signInWithGoogle();
        await syncService.syncData(context);
      }
      else{
        CacheHelper.put(key: 'connected', value: false);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var taskTitleController = TextEditingController();
    var dueDateController = TextEditingController();
    DateTime? dueDate;
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          // TaskBloc taskBloc = TaskBloc.get(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.paddingOf(context).top,
                        ),
                        const Text(
                          'Good Morning',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<TaskBloc>(context)
                                      .add(ChangeTasksType(index));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: BlocProvider.of<TaskBloc>(context)
                                                .currentIndex ==
                                            index
                                        ? const Color(0xff00CA5D)
                                        : const Color(0xff00CA5D)
                                            .withOpacity(.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: Text(
                                      index == 0
                                          ? 'All'
                                          : index == 1
                                              ? 'Not Done'
                                              : 'Done',
                                      style: TextStyle(
                                        color:
                                            BlocProvider.of<TaskBloc>(context)
                                                        .currentIndex ==
                                                    index
                                                ? Colors.white
                                                : const Color(0xff00CA5D),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    MediaQuery.sizeOf(context).width >= 600
                        ? FloatingActionButton(
                            backgroundColor: const Color(0xff00CA5D),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () async {
                              //await googleSignInService.signInWithGoogle();
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Material(
                                          color: Colors.transparent,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      )),
                                                ],
                                              ),
                                              const Text(
                                                'Create New Task',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              SizedBox(
                                                height: 40,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        const Color(0xffD9D9D9)
                                                            .withOpacity(.2),
                                                    hintText: 'Task title',
                                                  ),
                                                  controller:
                                                      taskTitleController,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: 40,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        const Color(0xffD9D9D9)
                                                            .withOpacity(.2),
                                                    hintText: 'Due Date',
                                                  ),
                                                  controller: dueDateController,
                                                  onTap: () async {
                                                    await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now()
                                                          .subtract(
                                                              const Duration(
                                                                  days: 30)),
                                                      lastDate: DateTime.now()
                                                          .add(const Duration(
                                                              days: 30)),
                                                    ).then((value) {
                                                      if (value != null) {
                                                        dueDate = value;
                                                        dueDateController
                                                            .text = DateFormat(
                                                                'EEE, dd/MM/yyyy')
                                                            .format(value);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Center(
                                                child: CustomButton(
                                                    child: const SizedBox(
                                                      width: 300,
                                                      height: 54,
                                                      child: Center(
                                                          child: Text(
                                                        'Save Task',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      )),
                                                    ),
                                                    onPressed: () async {
                                                      var newTask = TaskModel(
                                                        title:
                                                            taskTitleController
                                                                .text,
                                                        dueDate: dueDate!,
                                                        isCompleted: false,
                                                      );
                                                      BlocProvider.of<TaskBloc>(
                                                              context)
                                                          .add(
                                                              AddTask(newTask));
                                                      Navigator.pop(context);
                                                      taskTitleController
                                                          .clear();
                                                      dueDateController.clear();
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      if (state.tasks.isEmpty) {
                        return const Center(child: Text('No tasks available'));
                      } else {
                        return SingleChildScrollView(
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.start,
                              direction: Axis.horizontal,
                              children: List.generate(
                                state.tasks.length,
                                (index) {
                                  TaskModel task = state.tasks[index];
                                  return TaskCard(
                                    taskModel: task,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      return const Center(child: Text('Failed to load tasks'));
                    }
                  },
                ),
              ),
              MediaQuery.sizeOf(context).width < 600
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          child: const SizedBox(
                            width: 300,
                            height: 54,
                            child: Center(
                                child: Text(
                              'Create Task',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )),
                          ),
                          onPressed: () async {
                            // await googleSignInService.signInWithGoogle();

                            customBottomSheet(
                              context,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )),
                                  ],
                                ),
                                const Text(
                                  'Create New Task',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xffD9D9D9)
                                          .withOpacity(.2),
                                      hintText: 'Task title',
                                    ),
                                    controller: taskTitleController,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    keyboardType: TextInputType.none,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xffD9D9D9)
                                          .withOpacity(.2),
                                      hintText: 'Due Date',
                                    ),
                                    controller: dueDateController,
                                    onTap: () async {
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now()
                                            .subtract(const Duration(days: 30)),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 30)),
                                      ).then((value) {
                                        if (value != null) {
                                          dueDate = value;
                                          dueDateController.text =
                                              DateFormat('EEE, dd/MM/yyyy')
                                                  .format(value);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Center(
                                  child: CustomButton(
                                      child: const SizedBox(
                                        width: 300,
                                        height: 54,
                                        child: Center(
                                            child: Text(
                                          'Save Task',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        )),
                                      ),
                                      onPressed: () async {
                                        var newTask = TaskModel(
                                          title: taskTitleController.text,
                                          dueDate: dueDate!,
                                          isCompleted: false,
                                        );
                                        BlocProvider.of<TaskBloc>(context)
                                            .add(AddTask(newTask));
                                        Navigator.pop(context);
                                        taskTitleController.clear();
                                        dueDateController.clear();
                                      }),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
