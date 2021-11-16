import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:nibjobs/api/config/global.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/bloc/user/user_bloc.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  bool showInfo = false;
  @override
  Widget build(BuildContext context) {
    ApiGlobalConfig.get();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      color: CustomColor.GRAY_VERY_LIGHT,
                      width: double.infinity,
                      child: Image.asset(
                        "assets/images/addisababa_silhouet.png",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 35),
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringRsr.get(LanguageKey.SIGN_IN, firstCap: true)!,
                            style: const TextStyle(
                                fontSize: 28,
                                color: CustomColor.GRAY_LIGHT,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            StringRsr.get(LanguageKey.LET_US_KNOW_YOU,
                                firstCap: true)!,
                            style: const TextStyle(color: CustomColor.GRAY),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Form(
                                child: ListView(
//                            itemExtent: 50,
                                  children: <Widget>[
//                               TextFormField(
//                                 decoration: InputDecoration(hintText: "email"),
//                               ),
// // todo : un hide password view if user continues with email.
// //                              TextFormField(
// //                                decoration:
// //                                InputDecoration(hintText: "password"),
// //                              ),
//                               const SizedBox(
//                                 height: 16,
//                               ),
//                               SignInButton(
//                                 Buttons.Email,
//                                 onPressed: () {},
//                               ),
                                    SignInButton(
                                      Buttons.Google,
                                      text: StringRsr.get(
                                          LanguageKey.SIGN_IN_WITH_GOOGLE,
                                          firstCap: true),
                                      onPressed: () async {
                                        // todo : signin with the prefered method
                                        // todo : navigate to home
//                                  authService
//                                       .signInWithGoogle()
//                                      .then((firebaseUser) {
//                                    Navigator.pushReplacementNamed(
//                                        context, RouteTo.HOME);
//                                  });
                                        bool registerResult =
                                            await signInWithGoogle();

                                        if (registerResult) {
                                          BlocProvider.of<UserBloc>(context)
                                              .add(UserSignIn());
                                          Navigator.pushReplacementNamed(
                                              context, RouteTo.HOME);
                                        }
                                      },
                                    ),
                                    SignInButton(
                                      Buttons.Apple,
                                      text: StringRsr.get(
                                          LanguageKey.SIGN_IN_WITH_APPLE,
                                          firstCap: true),
                                      onPressed: () async {
                                        // todo : signin with the prefered method
                                        // todo : navigate to home
//                                  authService
//                                       .signInWithGoogle()
//                                      .then((firebaseUser) {
//                                    Navigator.pushReplacementNamed(
//                                        context, RouteTo.HOME);
//                                  });
                                        bool registerResult =
                                            await signInWithApple();

                                        if (registerResult) {
                                          BlocProvider.of<UserBloc>(context)
                                              .add(UserSignIn());
                                          Navigator.pushReplacementNamed(
                                              context, RouteTo.HOME);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                StringRsr.get(LanguageKey.I_WILL_DO_IT_LATTER,
                                    firstCap: true)!,
                                style: const TextStyle(color: CustomColor.GRAY),
                              ),
                              TextButton(
                                child: Text(
                                  StringRsr.get(LanguageKey.SKIP,
                                      firstCap: true)!,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                onPressed: () async {
                                  // setState(() {
                                  //   showInfo = true;
                                  // });
                                  bool registerResult =
                                      await signInAnonymously();

                                  if (registerResult) {
                                    // BlocProvider.of<UserBloc>(context)
                                    //     .add(UserSignIn());
                                    Navigator.pushReplacementNamed(
                                        context, RouteTo.HOME);
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
