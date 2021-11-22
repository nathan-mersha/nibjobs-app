import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'button_event.dart';
part 'button_state.dart';

class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  ButtonBloc(List<String> list) : super(ButtonInitial(categoryList: list));
  @override
  Stream<ButtonState> mapEventToState(ButtonEvent event) async* {
    // TODO: implement mapEventToState
    if (event is ButtonSet) {
      yield ButtonInitial(categoryList: event.categoryList);
    }
  }
}
