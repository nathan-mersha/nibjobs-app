part of 'sort_bloc.dart';

abstract class SortState extends Equatable {
  const SortState();
}

class SortInitial extends SortState {
  final bool sortUp;
  final bool sortUpNow;
  SortInitial({required this.sortUp, this.sortUpNow = true});
  @override
  List<Object> get props => [sortUp, sortUpNow];
}
