part of 'button_bloc.dart';

abstract class ButtonState extends Equatable {
  const ButtonState();
}

class ButtonInitial extends ButtonState {
  final List<String> categoryList;

  ButtonInitial({required this.categoryList});

  @override
  List<Object> get props => [categoryList];
}
