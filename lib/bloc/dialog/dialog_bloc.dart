import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dialog_event.dart';
part 'dialog_state.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  DialogBloc() : super(DialogInitial(dialogShow: false));

  @override
  Stream<DialogState> mapEventToState(DialogEvent event) async* {
    // TODO: implement mapEventToState
    if (event is DialogShow) {
      yield DialogInitial(dialogShow: event.dialogShow);
    }
  }
}
