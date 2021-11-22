part of 'button_bloc.dart';

abstract class ButtonEvent extends Equatable {
  const ButtonEvent();
}

class ButtonSet extends ButtonEvent {
  final List<String> categoryList;
  ButtonSet({required this.categoryList});

  @override
  List<Object?> get props => [categoryList];
}
