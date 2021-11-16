part of 'internet_bloc.dart';

@immutable
abstract class InternetEvent extends Equatable {
  const InternetEvent();
}

class InternetWifiOrMobile extends InternetEvent {
  final InternetType internetType;

  InternetWifiOrMobile({required this.internetType});

  @override
  // TODO: implement props
  List<Object> get props => [internetType];
}

class NoInternet extends InternetEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
