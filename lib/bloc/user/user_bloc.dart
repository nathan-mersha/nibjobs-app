import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/db/k_shared_preference.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
  String? uId;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userImage;

  UserBloc() : super(UserInitial()) {
    userState();
  }
  Future<void> userState() async {
    await userDataGetter();
    if (uId != null && uId != "" && uId != "null") {
      emitSignedIn(uId!, userName!, userEmail!, userPhone!, userImage!);
    } else {
      emitSignedOut();
    }
  }

  Future<void> userDataGetter() async {
    uId = await hSharedPreference.get(HSharedPreference.KEY_USER_ID);
    userName = await hSharedPreference.get(HSharedPreference.KEY_USER_NAME);
    userEmail = await hSharedPreference.get(HSharedPreference.KEY_USER_EMAIL);
    userPhone = await hSharedPreference.get(HSharedPreference.KEY_USER_PHONE);
    userImage =
        await hSharedPreference.get(HSharedPreference.KEY_USER_IMAGE_URL);
  }

  Future<void> userDataSetter() async {
    await hSharedPreference.set(HSharedPreference.KEY_USER_ID, null);
    await hSharedPreference.set(HSharedPreference.KEY_USER_NAME, null);
    await hSharedPreference.set(HSharedPreference.KEY_USER_EMAIL, null);
    await hSharedPreference.set(HSharedPreference.KEY_USER_PHONE, null);
    await hSharedPreference.set(HSharedPreference.KEY_USER_IMAGE_URL, null);
    List<String> list = [];
    await hSharedPreference.set(HSharedPreference.LIST_OF_FAV_CATEGORY, list);

    uId = null;
    userName = null;
    userEmail = null;
    userPhone = null;
    userImage = null;
  }

  void emitSignedIn(String uId, String userName, String userEmail,
          String userPhone, String userImage) =>
      emit(UserSignedInState(uId, userName, userEmail, userPhone, userImage));
  void emitSignedOut() => emit(UserSignedOutState());
  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is UserSignIn) {
      await userDataGetter();
      yield UserSignedInState(
          uId!, userName!, userEmail!, userPhone!, userImage!);
    } else if (event is UserSignOut) {
      yield UserInitial();
      final result = await signOut();

      if (result) {
        await userDataSetter();

        yield UserSignedOutState();
      } else {
        yield UserSigningOutErrorState();
      }
    }
  }
}
