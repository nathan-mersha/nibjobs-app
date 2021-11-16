part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserSigningOutErrorState extends UserState {
  @override
  List<Object> get props => [];
}

class UserSignedInState extends UserState {
  final String uId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userImage;
  UserSignedInState(
      this.uId, this.userName, this.userEmail, this.userPhone, this.userImage);
  @override
  List<Object> get props => [uId, userName, userEmail, userPhone, userImage];
}

class UserSignedOutState extends UserState {
  @override
  List<Object> get props => [];
}
