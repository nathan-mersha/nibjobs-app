import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sort_event.dart';
part 'sort_state.dart';

class SortBloc extends Bloc<SortEvent, SortState> {
  SortBloc() : super(SortInitial(sortUp: true, sortUpNow: false));

  @override
  Stream<SortState> mapEventToState(
    SortEvent event,
  ) async* {
    if (event is SortPriceType) {
      yield SortInitial(sortUp: event.sortUp);
    }
    // TODO: implement mapEventToState
  }
}
