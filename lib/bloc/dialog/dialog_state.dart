part of 'dialog_bloc.dart';

abstract class DialogState extends Equatable {
  const DialogState();
}

class DialogInitial extends DialogState {
  final bool dialogShow;
  DialogInitial({required this.dialogShow});
  @override
  // TODO: implement props
  List<Object> get props => [dialogShow];
}
