part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;


  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskChanged extends TaskState {
  final List<TaskModel> tasks;


  const TaskChanged(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {}
