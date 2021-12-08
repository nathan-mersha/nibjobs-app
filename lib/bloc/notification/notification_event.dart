part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationEventAdder extends NotificationEvent {
  final int counter;

  const NotificationEventAdder({required this.counter});
  @override
  // TODO: implement props
  List<Object?> get props => [counter];
}
