part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserSignIn extends UserEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UserSignOut extends UserEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
