part of 'down_bloc.dart';

abstract class DownState extends Equatable {
  const DownState();
}

class DownInitial extends DownState {
  @override
  List<Object> get props => [];
}

class DownSelected extends DownState {
  final Job job;
  final BuildContext context;
  DownSelected({required this.job, required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [job];
}
