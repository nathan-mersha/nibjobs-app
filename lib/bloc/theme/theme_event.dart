part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeChange extends ThemeEvent {
  final AppData appData;
  ThemeChange({required this.appData});
  @override
  // TODO: implement props
  List<Object> get props => [appData];
}
