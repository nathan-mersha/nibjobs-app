part of 'internet_bloc.dart';

@immutable
abstract class InternetState extends Equatable {
  const InternetState();
}

class InternetLoading extends InternetState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class InternetWifiOrMobileState extends InternetState {
  final InternetType internetType;

  InternetWifiOrMobileState({required this.internetType});

  @override
  List<Object> get props => [internetType];
}

class NoInternetState extends InternetState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
