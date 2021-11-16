part of 'down_bloc.dart';

@immutable
abstract class DownEvent extends Equatable {
  const DownEvent();
}

class DownSelectedEvent extends DownEvent {
  final Job job;
  final BuildContext context;
  DownSelectedEvent({required this.job, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [job];
}

class DownUnSelectedEvent extends DownEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
