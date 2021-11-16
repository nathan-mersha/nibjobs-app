part of 'dialog_bloc.dart';

abstract class DialogEvent extends Equatable {
  const DialogEvent();
}

class DialogShow extends DialogEvent {
  final bool dialogShow;
  DialogShow({required this.dialogShow});
  @override
  // TODO: implement props
  List<Object> get props => [dialogShow];
}
