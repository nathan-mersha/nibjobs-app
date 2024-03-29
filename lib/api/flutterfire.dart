import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nibjobs/dal/notification_dal.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/commerce/coupon.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/notification_model.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/model/profile/contact_us.dart';
import 'package:nibjobs/model/profile/user.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makeWebCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

GridView buildGridViewLoading(BuildContext context) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: jobViewH(context) == .20 ||
                jobViewH(context) == .37 ||
                jobViewH(context) == .36
            ? 2
            : 1,
        mainAxisSpacing: 10,
        childAspectRatio: jobViewH(context) == .7
            ? AppTheme.fullWidth(context) < 361
                ? 7 / 5
                : 7 / 4
            : jobViewH(context) == .20
                ? 7 / 3
                : 7 / 4),
    itemBuilder: (_, __) => Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: LightColor.iconColor, style: BorderStyle.none),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          // color:
          // isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Image thumbnail or image place holder

              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // Job name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: AppTheme.fullWidth(context) < 361
                                      ? 140
                                      : 240,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 40,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          // Job Author / Manufacturer
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 200,
                              height: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 3,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 350,
                          height: 15.0,
                          color: Colors.white,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 300,
                          height: 15.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 15.0,
                          color: Colors.white,
                        ),
                      ),

                      // Price and regular price
                      const SizedBox(
                        height: 2,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 60,
                                height: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )

                      // Job price and regular price
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
    itemCount: 20,
  );
}

void notificationFunctionSave(RemoteMessage? message) {
  if (message != null) {
    if (message.notification!.title!.toLowerCase() != "job notification") {
      NotificationModel notificationModel = NotificationModel(
        id: message.messageId,
        notificationServiceName: message.notification!.title,
        notificationServiceMessage: message.notification!.body,
        notificationServiceAmount: "0",
        notificationType: message.notification!.title,
        notificationServiceDate: DateTime.now().toString(),
        notificationServicePaymentMethodName: "wallet",
      );
      NotificationDAL.create(notificationModel);
    } else {
      // NotificationJobDAL.create(
      //     NotificationJobModel.toModelDB(jsonDecode(message.data["body"])));
    }
  }
}

showInfoToUser(
    BuildContext context, DialogType dialogType, String? title, String? desc,
    {Function? onOk}) {
  return AwesomeDialog(
    btnOkText: StringRsr.get(LanguageKey.OK, firstCap: true),
    btnCancelText: StringRsr.get(LanguageKey.CANCEL, firstCap: true),
    context: context,
    dialogType: dialogType,
    borderSide: const BorderSide(color: Colors.transparent, width: 2),
    width: 380,
    buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
    headerAnimationLoop: false,
    animType: AnimType.BOTTOMSLIDE,
    title: title,
    desc: desc,
    showCloseIcon: true,
    btnOkOnPress:  () {
      if (onOk != null) {
        onOk();
      }
    },
  ).show();
}

Future<bool> signIn(String email, String emailLink) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailLink(email: email, emailLink: emailLink);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    return await userDataSeter(user, userCredential);
  } catch (e) {
    return false;
  }
}

Future<bool> userDataSeter(User? user, UserCredential userCredential) async {
  if (user != null) {
    setUserData(user);
  } else {
    return false;
  }
  String? deviceId;
  try {
    deviceId = await PlatformDeviceId.getDeviceId;
  } on PlatformException {
    deviceId = 'Failed to get deviceId.';
  }
  String? deviceFCM;
  try {
    deviceFCM = await FirebaseMessaging.instance.getToken();
    print(" print(deviceFCM); $deviceFCM");
  } on PlatformException {
    deviceFCM = 'Failed to get FCM.';
    print(deviceFCM);
  }
  String? userEmail;
  userEmail = user.email;
  if (userEmail == null) {
    if (userCredential != null) {
      if (userCredential.additionalUserInfo != null) {
        userEmail = userCredential.additionalUserInfo!.profile?["email"];
      }
    }
  }

  UserModel userModel = UserModel(
    userId: user.uid,
    userName: user.displayName,
    displayName: user.displayName,
    email: userEmail,
    deviceId: deviceId,
    phoneNumber: user.phoneNumber,
    isEmailVerified: user.emailVerified,
    profilePicture: user.photoURL,
    fcm: deviceFCM,
    firstModified: DateTime.now(),
    lastModified: DateTime.now(),
  );
  final result = await addUser(userModel);
  if (!result) {
    return false;
  }
  return true;
}

String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<bool> signInWithApple() async {
  User user;

  try {
    if (!kIsWeb) {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      user = userCredential.user!;

      return await userDataSeter(user, userCredential);
    } else {
      final provider = OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');

      // Sign in the user with Firebase.

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(provider);
      user = userCredential.user!;
      return await userDataSeter(user, userCredential);
    }
  } catch (e) {
    debugPrint("error $e");
    return false;
  }
}

Future<void> setUserData(User user) async {
  HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;

  hSharedPreference.set(HSharedPreference.KEY_USER_ID, user.uid);
  hSharedPreference.set(HSharedPreference.KEY_USER_NAME, user.displayName);
  hSharedPreference.set(HSharedPreference.KEY_USER_EMAIL, user.email);
  hSharedPreference.set(HSharedPreference.KEY_USER_PHONE, user.phoneNumber);
  hSharedPreference.set(HSharedPreference.KEY_USER_IMAGE_URL, user.photoURL);

  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection(Company.COLLECTION_NAME)
      .doc(user.uid)
      .get();
  if (documentSnapshot.exists) {
    hSharedPreference.set(HSharedPreference.KEY_USER_HAS_SHOP, true);
  } else {
    hSharedPreference.set(HSharedPreference.KEY_USER_HAS_SHOP, false);
  }
}

UploadTask? uploadFileStore(String des, File file) {
  try {
    final ref = FirebaseStorage.instance.ref(des);
    return ref.putFile(file);
  } on FirebaseException catch (e) {
    return null;
  }
}

Future<bool> addCoupon(Coupon coupon) async {
  try {
    HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
    var uid = await hSharedPreference.get(HSharedPreference.KEY_USER_ID);

    //var uid = "f9fWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(Coupon.COLLECTION_NAME)
        .doc(uid)
        .collection("coupon")
        .doc(coupon.couponId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set(Coupon.toMap(coupon));
        return true;
      }
      transaction.update(documentReference, Coupon.toMap(coupon));
      return true;
    });

    return true;
  } catch (e) {}
  return false;
}

Future<bool> addUser(UserModel user) async {
  try {
    //var uid = FirebaseAuth.instance.currentUser.uid;
    var uid = user.userId;
    //var uid = "mixWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Users").doc(uid);
    HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        print("data is here ${snapshot.exists}");
        UserModel? oldUser = UserModel.toModel(snapshot.data()!);
        user.categoryList = oldUser.categoryList;
        user.categories = oldUser.categories;
        if (oldUser.categoryList!.isNotEmpty) {
          await hSharedPreference.set(HSharedPreference.LIST_OF_FAV_CATEGORY,
              oldUser.categoryList!.cast<String>());
          await hSharedPreference.set(HSharedPreference.LIST_OF_CATEGORY_ORDER,
              oldUser.categories!.cast<String>());
        }
        // documentReference.set(UserModel.toMap(user));
        // //documentReference.set(UserModel.toMap(user));
        // return true;
      } else {
        print("data is here ${snapshot.exists}");
        List list = await hSharedPreference
                .get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
        if (list.isNotEmpty) {
          user.categoryList = list;
        }
      }
      documentReference.set(UserModel.toMap(user));
      return true;
    });
    return true;
  } catch (e) {}
  return false;
}

Future<bool> updateUser(String userId, List<String> list) async {
  try {
    HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;

    //var uid = FirebaseAuth.instance.currentUser.uid;
    List<String> categories =
        await hSharedPreference.get(HSharedPreference.LIST_OF_CATEGORY_ORDER) ??
            [];
    var uid = userId;
    //var uid = "mixWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Users").doc(uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      UserModel userModel = UserModel.toModel(snapshot.data());
      userModel.categoryList = list;
      userModel.categories = categories;
      if (snapshot.exists) {
        documentReference.set(UserModel.toMap(userModel));
        return true;
      }
      return false;
    });

    return true;
  } catch (e) {}
  return false;
}

Future<bool> addJob(Job job) async {
  try {
    //var uid = FirebaseAuth.instance.currentUser.uid;
    var uid = job.id;
    job.approved = false;
    //var uid = "mixWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("job").doc(uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set(Job.toMap(job));
        return true;
      }
      transaction.update(documentReference, Job.toMap(job));
      return true;
    });

    return true;
  } catch (e) {}
  return false;
}

Future<bool> addContactUs(ContactUsModel contactUsModel) async {
  try {
    //var uid = FirebaseAuth.instance.currentUser.uid;
    var uid = contactUsModel.id;
    //var uid = "mixWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(ContactUsModel.COLLECTION_NAME)
        .doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set(ContactUsModel.toMap(contactUsModel));
        return true;
      }
      transaction.update(
          documentReference, ContactUsModel.toMap(contactUsModel));
      return true;
    });
    return true;
  } catch (e) {}
  return false;
}

Future<bool> addFavJob(Job? job) async {
  try {
    HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
    var uid = await hSharedPreference.get(HSharedPreference.KEY_USER_ID);

    //var uid = job.id;
    //var uid = "mixWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("favoriteJob")
        .doc(uid)
        .collection("job")
        .doc(job?.id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        documentReference.set(Job.toMap(job!));
        return true;
      }
      transaction.update(documentReference, Job.toMap(job!));
      return true;
    });

    return true;
  } catch (e) {}
  return false;
}

Future<bool> addCallJob(CalledJob calledJob) async {
  try {
    HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
    var uid = await hSharedPreference.get(HSharedPreference.KEY_USER_ID);
    //var uid = job.id;
    //var uid = "mixWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("calledJob")
        .doc(uid ?? FirebaseAuth.instance.currentUser!.uid)
        .collection("job")
        .doc(calledJob.job!.id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        try {
          documentReference.set(CalledJob.toMap(calledJob));
        } catch (e) {
          debugPrint("e $e");
        }

        return true;
      }
      transaction.update(documentReference, CalledJob.toMap(calledJob));
      return true;
    });

    return true;
  } catch (e) {}
  return false;
}

Future<bool> deleteFavJob(Job job) async {
  try {
    // var uid = job.id;
    HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
    var uid = await hSharedPreference.get(HSharedPreference.KEY_USER_ID);

    //var uid = job.id;
    //var uid = "mixWxOCNn0eI84R1A8Fa";
    //DocumentReference documentReference =
    await FirebaseFirestore.instance
        .collection("favoriteJob")
        .doc(uid)
        .collection("job")
        .doc(job.id)
        .delete();
    // await FirebaseFirestore.instance
    //     .collection(Job.COLLECTION_NAME)
    //     .doc(uid)
    //     .delete();

    return true;
  } catch (e) {}
  return false;
}

Future<bool> deleteJob(Job job) async {
  try {
    var uid = job.id;

    await FirebaseFirestore.instance
        .collection(Job.COLLECTION_NAME)
        .doc(uid)
        .delete();

    return true;
  } catch (e) {}
  return false;
}

Future<bool> addCompany(Company company) async {
  try {
    HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
    var uid = await hSharedPreference.get(HSharedPreference.KEY_USER_ID);

    company.userId = uid;
    company.id = uid;
    //var uid = "VHSWxOCNn0eI84R1A8Fa";
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(Company.COLLECTION_NAME).doc(uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set(Company.toMap(company));
        return true;
      }
      transaction.update(documentReference, Company.toMap(company));
      return true;
    });

    return true;
  } catch (e) {}
  return false;
}

Future<bool> signInAnonymously() async {
  try {
    await FirebaseAuth.instance.signInAnonymously();
    return true;
  } catch (e) {
    return false;
  }
}

// Future<bool> signInWithFacebook() async {
//   try {
//     if (!kIsWeb) {
//       User user = FirebaseAuth.instance.currentUser;
//       // Trigger the sign-in flow
//       final LoginResult loginResult = await FacebookAuth.instance.login();
//
//       // Create a credential from the access token
//       final OAuthCredential facebookAuthCredential =
//           FacebookAuthProvider.credential(loginResult.accessToken.token);
//
//
//       // Once signed in, return the UserCredential
//       // try {
//       //   UserCredential credential =
//       //   await user.linkWithCredential(facebookAuthCredential);
//       // } on FirebaseAuthException catch (e) {
//       //   if (e.code == 'provider-already-linked') {
//       //     await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//       //   }
//       // }
//
//       await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//
//       return true;
//     } else {
//       FacebookAuthProvider facebookProvider = FacebookAuthProvider();
//
//       facebookProvider.addScope('email');
//       facebookProvider.setCustomParameters({
//         'display': 'popup',
//       });
//
//       // Once signed in, return the UserCredential
//       await FirebaseAuth.instance.signInWithPopup(facebookProvider);
//       return true;
//     }
//     return true;
//   } on Exception catch (e) {
//     // TODO
//
//     return false;
//   }
// }

Future<bool> signOut() async {
  try {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {}
    try {
      //await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {}

    return true;
  } catch (e) {}
  return false;
}
