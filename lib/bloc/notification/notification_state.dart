part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  final int counter;
  int get counterGetter => counter;
  const NotificationInitial({required this.counter});
  @override
  List<Object> get props => [counter];
}
