part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasksFromLocal extends TaskEvent {}

class LoadTasksFromRemote extends TaskEvent {}

class ChangeTasksType extends TaskEvent {
  final int currentIndex;

  const ChangeTasksType(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

class AddTask extends TaskEvent {
  final TaskModel task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskModel task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final TaskModel task;

  const DeleteTask(this.task);

  @override
  List<Object> get props => [task];
}