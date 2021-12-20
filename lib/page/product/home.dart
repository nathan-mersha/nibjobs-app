import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/api/config/global.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/api/local.dart';
import 'package:nibjobs/bloc/down/down_bloc.dart';
import 'package:nibjobs/bloc/internet/internet_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/widget/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:nibjobs/widget/nav/category_job_nav.dart';
import 'package:nibjobs/widget/nav/favorite_job_nav.dart';
import 'package:nibjobs/widget/nav/menu.dart';
import 'package:nibjobs/widget/nav/products_nav.dart';
import 'package:nibjobs/widget/nav/shop_job_nav.dart';
import 'package:nibjobs/widget/product/bottom_sheet_product.dart';

class HomePage extends StatefulWidget {
  final bool isFavPageSelected;
  final bool isSubCategoryPageSelected;

  const HomePage(
      {Key? key,
      this.isFavPageSelected = false,
      this.isSubCategoryPageSelected = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool noInternet = false;
  bool isHomePageSelected = true;
  bool isFavPageSelected = false;
  bool isCategoryPageSelected = false;
  bool isSubCategoryPageSelected = false;
  bool showInfo = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
  void initState() {
    super.initState();
    isHomePageSelected =
        widget.isSubCategoryPageSelected || widget.isFavPageSelected
            ? false
            : true;
    isFavPageSelected = widget.isFavPageSelected;
    isCategoryPageSelected = widget.isSubCategoryPageSelected;
    initDynamicLinks();
    intShowInfo();
    HLocalNotification.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance");

      // if (message != null) {
      //   //debugPrint(message.notification.body);
      //   //debugPrint(message.notification.title);
      //   final routerFromMessage = message.data["route"];
      //   NotificationModel notificationModel = NotificationModel(
      //     id: message.messageId,
      //     notificationServiceName: message.notification!.title,
      //     notificationServiceMessage: message.notification!.body,
      //     notificationServiceAmount: "0",
      //     notificationType: message.notification!.title,
      //     notificationServiceDate: DateTime.now().toString(),
      //     notificationServicePaymentMethodName: "wallet",
      //   );
      //
      //   NotificationDAL.create(notificationModel);
      //   //debugPrint(routerFromMessage);
      // }
      notificationFunctionSave(message);
      print("onMessageOpenedApp");
      if (message != null) {
        if (message.data != null) {
          final routerFromMessage = message.data["notificationTag"];
          debugPrint("message.data ${message.data}");
          if (routerFromMessage == "gift") {
            makeWebCall("tel:*805*${message.data["code"]}#");
          } else {
            if (message.notification!.title!.toLowerCase() !=
                "job notification") {
              Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
            }
          }
        } else {
          if (message.notification!.title!.toLowerCase() !=
              "job notification") {
            Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
          }
        }
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging.onMessage");

      if (message.notification != null) {
        //debugPrint(message.notification.body);
        //debugPrint(message.notification.title);
        HLocalNotification.showNotification(message);
        // NotificationModel notificationModel = NotificationModel(
        //   id: message.messageId,
        //   notificationServiceName: message.notification!.title,
        //   notificationServiceMessage: message.notification!.body,
        //   notificationServiceAmount: "0",
        //   notificationType: message.notification!.title,
        //   notificationServiceDate: DateTime.now().toString(),
        //   notificationServicePaymentMethodName: "wallet",
        // );
        //
        // NotificationDAL.create(notificationModel);
        //Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
        notificationFunctionSave(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("onMessageOpenedApp");
      if (message != null) {
        if (message.data != null) {
          final routerFromMessage = message.data["notificationTag"];
          debugPrint("message.data ${message.data}");
          if (routerFromMessage == "gift") {
            makeWebCall("tel:*805*${message.data["code"]}#");
          } else {
            if (message.notification!.title!.toLowerCase() !=
                "job notification") {
              Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
            }
          }
        } else {
          if (message.notification!.title!.toLowerCase() !=
              "job notification") {
            Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
          }
        }
      }
    });
  }

  Future<void> intShowInfo() async {
    String uid =
        await hSharedPreference.get(HSharedPreference.KEY_USER_ID) ?? "";
    if (uid == "") {
      showInfo =
          await hSharedPreference.get(HSharedPreference.SHOW_INFO) ?? true;
      if (showInfo) {
        Navigator.of(context).pushNamed(RouteTo.GIFT);
      }
    } else {
      bool selectPreference =
          await hSharedPreference.get(HSharedPreference.SELECT_PREFERENCE) ??
              false;
      if (!selectPreference) {
        Navigator.of(context).pushNamed(RouteTo.CATEGORY_PREFERENCE);
      } else {
        debugPrint("preference selected ");
      }
    }
  }

  Future<void> deepLinkCode(Uri? deepLink) async {
    if (deepLink != null) {
      if (deepLink.queryParameters["id"] != null) {
        debugPrint("here ${deepLink.queryParameters["id"]}");
        String linkData = deepLink.queryParameters["id"]!;
        //debugPrint("linkData $linkData");
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection(Job.COLLECTION_NAME)
            .doc(linkData)
            .get();
        if (documentSnapshot.data() != null) {
          Job p = Job.toModel(documentSnapshot.data());
          //this is only for test
          p.id = documentSnapshot.id;
          Navigator.pushNamed(context, RouteTo.JOB_DETAIL, arguments: p);
        }
      } else if (deepLink.queryParameters["companyId"] != null) {
        debugPrint("here ${deepLink.queryParameters["companyId"]}");

        String linkData = deepLink.queryParameters["companyId"]!;
        //debugPrint("linkData $linkData");
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection(Company.COLLECTION_NAME)
            .doc(linkData)
            .get();
        if (documentSnapshot.data() != null) {
          Company p =
              Company.toModel(documentSnapshot.data() as Map<String, dynamic>);
          //this is only for test
          p.id = documentSnapshot.id;
          Navigator.pushNamed(context, RouteTo.JOB_SEARCH, arguments: p);
        }
      }
    }
  }

  Future<dynamic> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;
          //debugPrint("deepLink $deepLink");
          deepLinkCode(deepLink);
        },
        onError: (OnLinkErrorException e) async {});

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deepLink = data!.link;
    //debugPrint("deepLink $deepLink");
    deepLinkCode(deepLink);
  }

  Future<List<Category>> getCategory() async {
    return Future.value(global.localConfig.categories);
  }

  @override
  Widget build(BuildContext context) {
    ApiGlobalConfig.get();
    return Scaffold(
      key: _scaffoldKey,
      appBar: Menu.getAppBar(context, "Home",
          showCategory: true, scaffoldKey: _scaffoldKey),
      drawer: Menu.getSideDrawer(context),
      backgroundColor: Theme.of(context).backgroundColor,
      body: MultiBlocListener(
          listeners: [
            BlocListener<DownBloc, DownState>(
              listener: (context, state) {
                // TODO: implement listener}
                if (state is DownSelected) {
                  Scaffold.of(state.context).showBottomSheet(
                    (context) {
                      //debugPrint("${state.context.widget}");
                      return WillPopScope(
                        onWillPop: () {
                          BlocProvider.of<DownBloc>(context)
                              .add(DownUnSelectedEvent());
                          return Future.value(true);
                        },
                        child: Container(
                          height: 300,
                          child: Row(
                            children: [
                              buildJobViewSectionBottomSheet(
                                  state.job, context),
                            ],
                          ),
                        ),
                      );
                    },
                    elevation: 3,
                  );
                }
              },
            ),
            BlocListener<InternetBloc, InternetState>(
              listener: (context, state) {
                // TODO: implement listener}
                if (state is InternetWifiOrMobileState && noInternet) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      StringRsr.get(LanguageKey.CONNECTION_IS_BACK,
                          firstCap: true)!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(milliseconds: 500),
                  ));
                } else if (state is NoInternetState) {
                  noInternet = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      StringRsr.get(LanguageKey.NO_CONNECTION, firstCap: true)!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    duration: const Duration(seconds: 60),
                  ));
                }
              },
            ),
          ],
          child: Stack(
            fit: StackFit.expand,
            children: [
              Builder(
                builder: (context) {
                  if (isHomePageSelected) {
                    return JobNavigation();
                  } else if (isFavPageSelected || widget.isFavPageSelected) {
                    return FavoriteJobNavigation(
                      fromWhere: "Fav",
                    );
                  } else if (isCategoryPageSelected) {
                    return CategoryJobNavigation(
                      fromWhere: "Category",
                    );
                  } else if (isSubCategoryPageSelected ||
                      widget.isSubCategoryPageSelected) {
                    return CompanyJobNavigation(
                      fromWhere: "Company",
                    );
                  }
                  return JobNavigation();
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomBottomNavigationBar(
                  isFavPageSelected: widget.isFavPageSelected,
                  isSubCategoryPageSelected: widget.isSubCategoryPageSelected,
                  onIconPresedCallback: onBottomIconPressed,
                ),
              ),
            ],
          )),
    );
  }

  void onBottomIconPressed(int index) {
    BlocProvider.of<SearchBloc>(context)
        .add(SearchViewEvent(searchInView: true));
    if (index == 0) {
      setState(() {
        isHomePageSelected = true;
        isFavPageSelected = false;
        isCategoryPageSelected = false;
        isSubCategoryPageSelected = false;
      });
    } else if (index == 2) {
      setState(() {
        isFavPageSelected = true;
        isHomePageSelected = false;
        isCategoryPageSelected = false;
        isSubCategoryPageSelected = false;
      });
    } else if (index == 3) {
      setState(() {
        isCategoryPageSelected = true;
        isFavPageSelected = false;
        isHomePageSelected = false;
        isSubCategoryPageSelected = false;
      });
    } else if (index == 1) {
      setState(() {
        isSubCategoryPageSelected = true;
        isCategoryPageSelected = false;
        isFavPageSelected = false;
        isHomePageSelected = false;
      });
    }
  }
}
