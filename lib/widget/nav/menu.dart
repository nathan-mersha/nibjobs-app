import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/user/user_bloc.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/page/product/home.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/nib_custom_icons_icons.dart';
import 'package:share/share.dart';

import '../../route/route.dart';

class Menu {
  static bool isSelected = false;
  static HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;

  /// Get menu side drawer
  static bool isDark = false;
  static userHasCompany() async {
    return await hSharedPreference.get(HSharedPreference.KEY_USER_HAS_SHOP) ??
        false;
  }

  static getSideDrawer(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 40.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state is UserSignedInState) {
                    return state.userImage == null || state.userImage == ""
                        ? Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/default_avatar.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                image: NetworkImage(
                                  state.userImage,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                  } else {
                    return Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/default_avatar.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                }),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state is UserSignedInState) {
                    return Text(
                      state.userName == ""
                          ? StringRsr.get(LanguageKey.NO_USERNAME_RETRIEVED,
                              firstCap: true)!
                          : state.userName,
                      style: const TextStyle(
                          color: CustomColor.GRAY_DARK,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    );
                  } else if (state is UserSignedOutState) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteTo.PROFILE_SIGN_IN);
                      },
                      child: Text(
                        StringRsr.get(LanguageKey.SIGN_IN, firstCap: true)!,
                        style: const TextStyle(
                            color: CustomColor.GRAY_DARK,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    );
                  } else if (state is UserInitial) {
                    return Container();
                  }
                  return Container();
                }),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserSignedInState) {
                      return Text(
                        // StringRsr.get(LanguageKey.WELCOME_TO_OUR_FAMILY,
                        //     firstCap: true),
                        state.userEmail != ""
                            ? state.userEmail
                            : StringRsr.get(LanguageKey.NO_EMAIL_RETRIEVED,
                                firstCap: true)!,
                        style: const TextStyle(
                          color: CustomColor.GRAY_LIGHT,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (state is UserSignedOutState) {
                      return Text(
                        StringRsr.get(LanguageKey.LET_US_KNOW_YOU,
                            firstCap: true)!,
                        style: const TextStyle(
                          color: CustomColor.GRAY_LIGHT,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (state is UserInitial) {
                      return Container();
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        ),

        const SizedBox(
          height: 30,
        ),
        Divider(
          thickness: 3,
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            leading: const Icon(
              NibCustomIcons.home,
              color: Color(0xff808080),
            ),
            title: Text(
              StringRsr.get(LanguageKey.HOME, firstCap: true)!,
              style: const TextStyle(color: Color(0xff000000)),
            ),
            onTap: () {
              // todo : navigate to home
              Navigator.of(context).pop();
              // Navigator.pop(context);
              Navigator.pushReplacementNamed(context, RouteTo.HOME);
            },
          ),
        ),
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserSignedInState) {
              return FutureBuilder(
                  future: userHasCompany(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: ListTile(
                          leading: const Icon(
                            NibCustomIcons.companies,
                            color: Color(0xff808080),
                          ),
                          title: Text(
                            StringRsr.get(LanguageKey.MY_SHOP, firstCap: true)!,
                            style: const TextStyle(color: Color(0xff000000)),
                          ),
                          onTap: () async {
                            // todo : navigate
                            var uid = state.uId;

                            DocumentSnapshot? documentSnapshot =
                                await FirebaseFirestore.instance
                                    .collection(Company.COLLECTION_NAME)
                                    .doc(uid)
                                    .get();
                            // if (documentSnapshot.data() == null) return ;
                            Company companyData = Company.toModel(
                                documentSnapshot.data()
                                    as Map<String, dynamic>);
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, RouteTo.SHOP_EDIT,
                                arguments: companyData);
                          },
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: ListTile(
                        leading: const Icon(
                          NibCustomIcons.companies,
                          color: Color(0xff808080),
                        ),
                        title: Text(
                          StringRsr.get(LanguageKey.CREATE_SHOP,
                              firstCap: true)!,
                          style: const TextStyle(color: Color(0xff000000)),
                        ),
                        onTap: () async {
                          // todo : navigate
                          var uid = state.uId;

                          DocumentSnapshot documentSnapshot =
                              await FirebaseFirestore.instance
                                  .collection(Company.COLLECTION_NAME)
                                  .doc(uid)
                                  .get();
                          // if (documentSnapshot.data() == null) return ;
                          Company companyData = Company.toModel(
                              documentSnapshot.data() as Map<String, dynamic>);
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, RouteTo.SHOP_EDIT,
                              arguments: companyData);
                        },
                      ),
                    );
                  });
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: ListTile(
                  leading: const Icon(
                    NibCustomIcons.companies,
                    color: Color(0xff808080),
                  ),
                  title: Text(
                    StringRsr.get(LanguageKey.CREATE_SHOP, firstCap: true)!,
                    style: const TextStyle(color: Color(0xff000000)),
                  ),
                  onTap: () async {
                    AwesomeDialog(
                      btnOkText: StringRsr.get(LanguageKey.OK, firstCap: true),
                      btnCancelText:
                          StringRsr.get(LanguageKey.CANCEL, firstCap: true),
                      context: context,
                      dialogType: DialogType.INFO_REVERSED,
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                      width: 380,
                      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: StringRsr.get(LanguageKey.SIGN_IN, firstCap: true),
                      desc: StringRsr.get(LanguageKey.YOU_HAVE_TO_SIGN_IN_FIRST,
                          firstCap: true),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, RouteTo.PROFILE_SIGN_IN);
                      },
                    ).show();
                  },
                ),
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            leading: const Icon(
              NibCustomIcons.favorite,
              color: Color(0xff808080),
            ),
            title: Text(
              StringRsr.get(LanguageKey.FAVORITE, firstCap: true)!,
              style: const TextStyle(color: Color(0xff000000)),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return HomePage(
                  isFavPageSelected: true,
                );
              }));
              // Navigator.pop(context);
              //Navigator.pushNamed(context, RouteTo.HOME);

              // todo : go to settings page here
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            leading: Icon(
              NibCustomIcons.category,
              color: Color(0xff808080),
            ),
            title: Text(
              StringRsr.get(LanguageKey.CATEGORY, firstCap: true)!,
              style: const TextStyle(color: Color(0xff000000)),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return HomePage(
                  isSubCategoryPageSelected: true,
                );
              }));
              // Navigator.pop(context);
              // Navigator.pushNamed(context, RouteTo.SETTING_GENERAL);

              // todo : go to settings page here
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            leading: Icon(
              NibCustomIcons.notification,
              color: Color(0xff808080),
            ),
            title: Text(
              StringRsr.get(LanguageKey.NOTIFICATION, firstCap: true)!,
              style: const TextStyle(color: Color(0xff000000)),
            ),
            onTap: () {
              // todo : navigate to home
              Navigator.of(context).pop();
              // Navigator.pop(context);
              Navigator.pushNamed(context, RouteTo.NOTIFICATION);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Divider(
              indent: 15.0, height: 5, color: Theme.of(context).dividerColor),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            leading: Icon(
              NibCustomIcons.settings,
              color: Color(0xff808080),
            ),
            title: Text(
              StringRsr.get(LanguageKey.SETTINGS, firstCap: true)!,
              style: const TextStyle(color: Color(0xff000000)),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RouteTo.SETTING_GENERAL);

              // todo : go to settings page here
            },
          ),
        ),
        // Divider(indent: 15.0, height: 2, color: Theme.of(context).dividerColor),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            leading: Icon(
              NibCustomIcons.send,
              color: Color(0xff808080),
            ),
            title: Text(
              StringRsr.get(LanguageKey.CONTACT_US, firstCap: true)!,
              style: const TextStyle(color: Color(0xff000000)),
            ),
            onTap: () {
              Navigator.pop(context); // Pops the navigation side drawer
              Navigator.pushNamed(context, RouteTo.INFO_CONTACT_US);
              // todo : do contact us here
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            leading: Icon(
              NibCustomIcons.share,
              color: Color(0xff808080),
            ),
            title: Text(
              StringRsr.get(LanguageKey.SHARE, firstCap: true)!,
              style: const TextStyle(color: Color(0xff000000)),
            ),
            onTap: () {
              // todo : share here
              String shareMessage =
                  "${StringRsr.get(LanguageKey.DOWNLOAD_KELEM_APP, lcl: LanguageKey.ENGLISH_LC, firstCap: true)}"
                  "\n${StringRsr.get(LanguageKey.DOWNLOAD_KELEM_APP, lcl: LanguageKey.AMHARIC_LC)}"
                  "\n\nPlaystore\nhttps://bit.ly/kelem_app_playstore_v1"
                  "\n\nAppstore\nhttps://bit.ly/kelem_app_appstore_v1";
              Share.share(shareMessage);
            },
          ),
        ),

        // ListTile(
        //   leading: Icon(Icons.help),
        //   title: Text("change Theme"),
        //   trailing: Switch(
        //     value: isDark,
        //     onChanged: (value) {
        //       isDark = value;
        //       if (value) {
        //         BlocProvider.of<ThemeBloc>(context)
        //             .add(ThemeChange(appData: AppData.Dark));
        //       } else {
        //         BlocProvider.of<ThemeBloc>(context)
        //             .add(ThemeChange(appData: AppData.Light));
        //       }
        //     },
        //   ),
        //   onTap: () {
        //     //Navigator.pop(context); // Pops the navigation side drawer
        //     // todo : help page here.
        //   },
        // ),
        // BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        //   if (state is UserSignedInState) {
        //     return ListTile(
        //       leading: Icon(
        //         Icons.logout,
        //         color: Theme.of(context).primaryColor,
        //       ),
        //       title: Text(
        //         StringRsr.get(LanguageKey.SING_OUT, firstCap: true),
        //         style: const TextStyle(color: Theme.of(context).primaryColor),
        //       ),
        //       onTap: () {
        //          AwesomeDialog(
        //             btnOkText:StringRsr.get(LanguageKey.OK,firstCap: true),
        //           btnCancelText:StringRsr.get(LanguageKey.CANCEL,firstCap: true),
        //           context: context,
        //           dialogType: DialogType.INFO_REVERSED,
        //           borderSide: BorderSide(color: Colors.transparent, width: 2),
        //           width: 380,
        //           buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        //           headerAnimationLoop: false,
        //           animType: AnimType.BOTTOMSLIDE,
        //           title: StringRsr.get(LanguageKey.SING_OUT, firstCap: true),
        //           desc: StringRsr.get(LanguageKey.DO_YOU_WANT_TO_SING_OUT,
        //               firstCap: true),
        //           showCloseIcon: true,
        //           btnCancelOnPress: () {},
        //           btnOkOnPress: () async {
        //             BlocProvider.of<UserBloc>(context).add(UserSignOut());
        //
        //             BlocListener<UserBloc, UserState>(
        //               listener: (context, state) {
        //                 // TODO: implement listener}
        //                 if (state is UserSignedOutState) {
        //                    AwesomeDialog(
        //btnOkText:StringRsr.get(LanguageKey.OK,firstCap: true),
        //btnCancelText:StringRsr.get(LanguageKey.CANCEL,firstCap: true),
        //                     context: context,
        //                     dialogType: DialogType.SUCCES,
        //                     borderSide:
        //                         BorderSide(color: Colors.transparent, width: 2),
        //                     width: 380,
        //                     buttonsBorderRadius:
        //                         BorderRadius.all(Radius.circular(2)),
        //                     headerAnimationLoop: false,
        //                     animType: AnimType.BOTTOMSLIDE,
        //                     title: StringRsr.get(LanguageKey.SUCCESSFUL,
        //                         firstCap: true),
        //                     desc: StringRsr.get(
        //                         LanguageKey.YOU_HAVE_SUCCESSFUL_SIGN_OUT,
        //                         firstCap: true),
        //                     showCloseIcon: true,
        //                     btnOkOnPress: () {},
        //                   )..show();
        //                 }
        //               },
        //             );
        //           },
        //         )..show();
        //
        //         //Navigator.pop(context); // Pops the navigation side drawer
        //         // todo : help page here.
        //       },
        //     );
        //   } else if (state is UserSignedOutState) {
        //     return ListTile(
        //       leading: Icon(
        //         Icons.login,
        //         color: Theme.of(context).primaryColor,
        //       ),
        //       title: Text(
        //         StringRsr.get(LanguageKey.SING_IN, firstCap: true),
        //         style: const TextStyle(color: Theme.of(context).primaryColor),
        //       ),
        //       onTap: () {
        //         Navigator.pushNamed(context, RouteTo.PROFILE_SIGN_IN);
        //
        //         //Navigator.pop(context); // Pops the navigation side drawer
        //         // todo : help page here.
        //       },
        //     );
        //   } else if (state is UserInitial) {
        //     return ListTile();
        //   }
        //   return null;
        // }),
      ],
    ));
  }

  static getAppBar(BuildContext context, String title,
      {bool showCategory = false, GlobalKey<ScaffoldState>? scaffoldKey}) {
    return AppBar(
      backgroundColor: LightColor.lightGrey,
      leading: IconButton(
        icon: const Icon(
          NibCustomIcons.menu,
          size: 14,
          color: Colors.black,
        ),
        onPressed: () {
          scaffoldKey!.currentState!.openDrawer();
        },
      ),
      actions: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          child: Container(
            //padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: LightColor.lightGrey,
            ),
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserSignedInState) {
                return GestureDetector(
                    onTap: () {
                      AwesomeDialog(
                        btnOkText:
                            StringRsr.get(LanguageKey.OK, firstCap: true),
                        btnCancelText:
                            StringRsr.get(LanguageKey.CANCEL, firstCap: true),
                        context: context,
                        dialogType: DialogType.INFO_REVERSED,
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 2),
                        width: 380,
                        buttonsBorderRadius:
                            BorderRadius.all(Radius.circular(2)),
                        headerAnimationLoop: false,
                        animType: AnimType.BOTTOMSLIDE,
                        title:
                            StringRsr.get(LanguageKey.SIGN_OUT, firstCap: true),
                        desc: StringRsr.get(LanguageKey.DO_YOU_WANT_TO_SIGN_OUT,
                            firstCap: true),
                        showCloseIcon: true,
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          BlocProvider.of<UserBloc>(context).add(UserSignOut());
                          Navigator.pushNamed(context, RouteTo.PROFILE_SIGN_IN);
                          BlocListener<UserBloc, UserState>(
                            listener: (context, state) {
                              // TODO: implement listener}
                              if (state is UserSignedOutState) {
                                AwesomeDialog(
                                  btnOkText: StringRsr.get(LanguageKey.OK,
                                      firstCap: true),
                                  btnCancelText: StringRsr.get(
                                      LanguageKey.CANCEL,
                                      firstCap: true),
                                  context: context,
                                  dialogType: DialogType.SUCCES,
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 2),
                                  width: 380,
                                  buttonsBorderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  headerAnimationLoop: false,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: StringRsr.get(LanguageKey.SUCCESSFUL,
                                      firstCap: true),
                                  desc: StringRsr.get(
                                      LanguageKey.YOU_HAVE_SUCCESSFUL_SIGN_OUT,
                                      firstCap: true),
                                  showCloseIcon: true,
                                  btnOkOnPress: () {
                                    Navigator.pushNamed(
                                        context, RouteTo.PROFILE_SIGN_IN);
                                  },
                                ).show();
                              }
                            },
                          );
                        },
                      ).show();
                    },
                    child: state.userImage == null
                        ? Container(
                            margin: EdgeInsets.only(top: 16, bottom: 9),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/default_avatar.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 16, bottom: 9),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image: NetworkImage(
                                  state.userImage,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ));
              } else if (state is UserSignedOutState) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteTo.PROFILE_SIGN_IN);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 16, bottom: 9),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: const DecorationImage(
                        image: AssetImage(
                          "assets/images/default_avatar.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else if (state is UserInitial) {
                return Container();
              }
              return Container();
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserSignedInState) {
              return GestureDetector(
                onTap: () {
                  AwesomeDialog(
                    btnOkText: StringRsr.get(LanguageKey.OK, firstCap: true),
                    btnCancelText:
                        StringRsr.get(LanguageKey.CANCEL, firstCap: true),
                    context: context,
                    dialogType: DialogType.INFO_REVERSED,
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                    width: 380,
                    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                    headerAnimationLoop: false,
                    animType: AnimType.BOTTOMSLIDE,
                    title: StringRsr.get(LanguageKey.SIGN_OUT, firstCap: true),
                    desc: StringRsr.get(LanguageKey.DO_YOU_WANT_TO_SIGN_OUT,
                        firstCap: true),
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      BlocProvider.of<UserBloc>(context).add(UserSignOut());
                      Navigator.pushNamed(context, RouteTo.PROFILE_SIGN_IN);
                      BlocListener<UserBloc, UserState>(
                        listener: (context, state) {
                          // TODO: implement listener}
                          if (state is UserSignedOutState) {
                            AwesomeDialog(
                              btnOkText:
                                  StringRsr.get(LanguageKey.OK, firstCap: true),
                              btnCancelText: StringRsr.get(LanguageKey.CANCEL,
                                  firstCap: true),
                              context: context,
                              dialogType: DialogType.SUCCES,
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2),
                              width: 380,
                              buttonsBorderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              headerAnimationLoop: false,
                              animType: AnimType.BOTTOMSLIDE,
                              title: StringRsr.get(LanguageKey.SUCCESSFUL,
                                  firstCap: true),
                              desc: StringRsr.get(
                                  LanguageKey.YOU_HAVE_SUCCESSFUL_SIGN_OUT,
                                  firstCap: true),
                              showCloseIcon: true,
                              btnOkOnPress: () {
                                Navigator.pushNamed(
                                    context, RouteTo.PROFILE_SIGN_IN);
                              },
                            ).show();
                          }
                        },
                      );
                    },
                  ).show();
                },
                child: const Icon(
                  Icons.logout,
                  color: Colors.grey,
                ),
              );
            } else if (state is UserSignedOutState) {
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteTo.PROFILE_SIGN_IN);
                  },
                  child: Icon(
                    Icons.login,
                    color: Colors.grey,
                  ));
            } else if (state is UserInitial) {
              return Container();
            }
            return Container();
          }),
        ),
      ],
      //showCategory ? CategoryMenu() : Container()
      //backgroundColor: LightColor.lightGrey,
      elevation: 0,
    );
  }
}