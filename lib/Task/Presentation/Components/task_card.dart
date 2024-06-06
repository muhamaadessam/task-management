import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task/Task/Data/Models/task_model.dart';

import '../../../Core/Components/custom_Button.dart';
import '../../../Core/Components/custom_bottom_sheet.dart';
import '../Controllers/task_bloc.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.taskModel});

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    var taskTitleController = TextEditingController();
    var dueDateController = TextEditingController();
    DateTime? dueDate;
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        TaskBloc taskBloc = TaskBloc.get(context);
        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24),
            child: SizedBox(
              width: 300,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      taskTitleController.text = taskModel.title!;
                      dueDateController.text = DateFormat('EEE. dd/MM/yyyy')
                          .format(taskModel.dueDate!);
                      dueDate = taskModel.dueDate;
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
                            'Edit Task',
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
                                fillColor:
                                    const Color(0xffD9D9D9).withOpacity(.2),
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
                                fillColor:
                                    const Color(0xffD9D9D9).withOpacity(.2),
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
                                  taskModel
                                    ..title = taskTitleController.text
                                    ..dueDate = dueDate!;
                                  BlocProvider.of<TaskBloc>(context)
                                      .add(UpdateTask(taskModel));
                                  Navigator.pop(context);
                                  taskTitleController.clear();
                                  dueDateController.clear();
                                }),
                          ),
                        ],
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            taskModel.title!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Due Date: ${DateFormat('EEE. dd/MM/yyyy')
                              .format(taskModel.dueDate!)}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  taskModel.isCompleted!
                      ? Image.asset(
                          'assets/png/done.png',
                          width: 36,
                        )
                      : InkWell(
                          onTap: () {
                            taskModel.isCompleted = true;
                            taskBloc.add(UpdateTask(taskModel));
                          },
                          child: Image.asset(
                            'assets/png/notDone.png',
                            width: 36,
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
