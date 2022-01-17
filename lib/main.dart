import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nibjobs/bloc/ads/adses_cubit.dart';
import 'package:nibjobs/bloc/dialog/dialog_bloc.dart';
import 'package:nibjobs/bloc/notification/notification_bloc.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/theme.dart';

import 'api/app_builder.dart';
import 'api/config/global.dart';
import 'api/flutterfire.dart';
import 'bloc/ads/ad_helper.dart';
import 'bloc/button/button_bloc.dart';
import 'bloc/description/description_cubit.dart';
import 'bloc/down/down_bloc.dart';
import 'bloc/images/image_cubit.dart';
import 'bloc/internet/internet_bloc.dart';
import 'bloc/mybloc.dart';
import 'bloc/nav/nav_bloc.dart';
import 'bloc/search/search_bloc.dart';
import 'bloc/sort/sort_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'dal/create_all_table.dart';
import 'db/k_shared_preference.dart';

String backgroundMessageTest = "";
Future<void> backgroundMessage(RemoteMessage? message) async {
  backgroundMessageTest = "backgroundMessage";

  notificationFunctionSave(message);
}

AdHelper? adState;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final adsInitial = MobileAds.instance.initialize();
  adState = AdHelper(initialized: adsInitial);
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static var routes;
  List<String>? proFavList;
  late String themeDataState;
  HSharedPreference hSharedPreference = HSharedPreference();

  @override
  void initState() {
    super.initState();

    func();
    WidgetsBinding.instance!.addObserver(this);
  }

  Future<String> themeSet() async {
    themeDataState =
        await hSharedPreference.get(HSharedPreference.THEME_MODE) ?? "";
    return themeDataState;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      await hSharedPreference.set(HSharedPreference.KEY_USER_LAST_SEEN,
          DateTime.now().toIso8601String());
    } else if (state == AppLifecycleState.paused) {
      await hSharedPreference.set(HSharedPreference.KEY_USER_LAST_SEEN,
          DateTime.now().toIso8601String());
    } else if (state == AppLifecycleState.resumed) {}
  }

  void func() async {
    proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
  }

  void timeSetter() async {
    Timer.periodic(const Duration(minutes: 2, seconds: 1), (timer) {
      //code to run on every 30 minutes 1 seconds
      hSharedPreference.set(HSharedPreference.KEY_USER_LAST_SEEN,
          DateTime.now().toIso8601String());
    });
  }

  @override
  Widget build(BuildContext context) {
    CreateAllDAL.createDatabase();
    timeSetter();
    routes = RouteTo().routes;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    /// Creating an open socket connection to listen to global configuration object
    ApiGlobalConfig.get();
    Future setSPInitValues(BuildContext context) async {
      HSharedPreference hSP = GetHSPInstance.hSharedPreference;

      return hSP.get(HSharedPreference.LOCALE).then((value) {
        if (value == null) {
          StringRsr.locale = "en";
        } else {
          StringRsr.locale = value;
        }

        // return hSP.get(HSharedPreference.THEME).then((value) {
        //   if (value == null) {
        //     HTheme.currentTheme = HTheme.warm;
        //   } else {
        //     HTheme.currentTheme = value;
        //   }
        //   return true;
        // });
      });
    }

    return FutureBuilder(
        future: themeSet(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ThemeBloc(snapshot.data as String),
                ),
                BlocProvider(
                  create: (context) => ButtonBloc(proFavList!),
                ),
                BlocProvider(
                  create: (context) => NotificationBloc(),
                ),
                BlocProvider(
                  create: (context) => NavBloc(),
                ),
                BlocProvider(
                  create: (context) => AdsesCubit(adState: adState!),
                ),
                BlocProvider(
                  create: (context) => DialogBloc(),
                ),
                BlocProvider(
                  create: (context) => SearchBloc(),
                ),
                BlocProvider(
                  create: (context) => DownBloc(),
                ),
                BlocProvider(
                  create: (context) => UserBloc(),
                ),
                BlocProvider(
                  create: (context) => ImageCubit(),
                ),
                BlocProvider(
                  create: (context) => SortBloc(),
                ),
                BlocProvider(
                  create: (context) => DescriptionCubit(),
                ),
                BlocProvider(
                  create: (context) =>
                      InternetBloc(connectivity: Connectivity()),
                ),
              ],
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return FutureBuilder(
                    future: setSPInitValues(context),
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.none &&
                          projectSnap.hasData == null) {
                        return const LoadingApp();
                      } else {
                        if (projectSnap.data == true) {
                          return AppBuilder(builder: (context) {
                            return MaterialApp(
                                locale: DevicePreview.locale(
                                    context), // Add the locale here
                                builder: DevicePreview.appBuilder,
                                debugShowCheckedModeBanner: false,
                                title: "nib jobs",
                                theme: state.themeData,
                                routes: routes);
                          });
                        } else {
                          return AppBuilder(builder: (context) {
                            return MaterialApp(
                                locale: DevicePreview.locale(
                                    context), // Add the locale here
                                builder: DevicePreview.appBuilder,
                                debugShowCheckedModeBanner: false,
                                title: "nib jobs",
                                theme: state.themeData,
                                routes: routes);
                          });
                        }
                      }
                    },
                  );
                },
              ),
            );
          }
          return const LoadingApp();
        });
  }
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(
            backgroundColor: Color(AppTheme.darkPink),
            strokeWidth: 3,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "initializing NibJobs application",
            textDirection: TextDirection.ltr,
            style: TextStyle(
                color: CustomColor.GRAY_LIGHT,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "populating db ...",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: CustomColor.GRAY,
              fontSize: 9,
            ),
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}
