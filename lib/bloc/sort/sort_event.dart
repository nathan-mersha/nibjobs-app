part of 'sort_bloc.dart';

abstract class SortEvent extends Equatable {
  const SortEvent();
}

class SortPriceType extends SortEvent {
  final bool sortUp;
  final bool sortUpNow;

  SortPriceType({required this.sortUp, this.sortUpNow = true});

  @override
  // TODO: implement props
  List<Object> get props => [sortUp, sortUpNow];
}
