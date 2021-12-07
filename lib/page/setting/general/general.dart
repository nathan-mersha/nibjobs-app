import 'package:flutter/material.dart';
import 'package:nibjobs/api/app_builder.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';

class GeneralSettingsPage extends StatefulWidget {
  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  static bool isDark = false;

  bool enableNotifications = true;

  String selectedFontSize = "small";

  bool agentEnabled = true;

  HSharedPreference hSP = GetHSPInstance.hSharedPreference;

  static String defaultLanguage = StringRsr.get(LanguageKey.ENGLISH_LC)!;

  List<String>? themeList;

  List<String>? fontSizeList;

  HSharedPreference localPreference = GetHSPInstance.hSharedPreference;

  String selectedLanguage = defaultLanguage;

  String proceedButtonTxt = StringRsr.get(LanguageKey.PROCEED)!;

  void initState() {
    super.initState();
    setterSetting();
  }

  Future<void> setterSetting() async {
    selectedLanguage = StringRsr.get(await hSP.get(HSharedPreference.LOCALE))!;
    setState(() {});
  }

  setSelectedLanguage(String newSelectedLanguage) {
    setState(() {
      selectedLanguage = newSelectedLanguage;
      String locale = StringRsr.languageMapping[selectedLanguage]!;
      proceedButtonTxt = StringRsr.get(LanguageKey.PROCEED, lcl: locale)!;
      if (locale != null) {
        localPreference.set(HSharedPreference.LOCALE, locale).then((value) {
          StringRsr.locale = locale;
          AppBuilder.of(context).rebuild();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    themeList = [
      "WARM",
      "COOL",
    ];
    fontSizeList = [
      "LARGE",
      "MEDIUM",
      "SMAll",
    ];
    Widget getAppBar2(BuildContext context, String job,
        {bool showCategory = false}) {
      return AppBar(
        backgroundColor: LightColor.background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: CustomColor.GRAY_DARK,
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        actions: <Widget>[],
        //showCategory ? CategoryMenu() : Container()
        //backgroundColor: LightColor.lightGrey,
        elevation: 0,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: getAppBar2(context, "General Settings")),
      //drawer: Menu.getSideDrawer(context),
      body: Container(
        padding: AppTheme.padding,
        color: LightColor.background,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: ListView(itemExtent: 45, children: <Widget>[
                  // Services
                  Text(
                    StringRsr.get(LanguageKey.SETTINGS, firstCap: true)!,
                    style: const TextStyle(
                        fontSize: 23,
                        color: CustomColor.GRAY_DARK,
                        fontWeight: FontWeight.bold),
                  ),

                  ListTile(
                    title: Text(
                      StringRsr.get(LanguageKey.GENERAL, firstCap: true)!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: CustomColor.GRAY_DARK,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text(
                        "please select language / እባክዎ ቋንቋ ይምረጡ",
                      ),
                      onChanged: (studentId) {
                        // on package change
                        setSelectedLanguage(studentId!);
                      },
                      value: selectedLanguage,
                      items:
                          //"english", "amharic"
                          [
                        StringRsr.get(LanguageKey.ENGLISH_LC)!,
                        StringRsr.get(LanguageKey.AMHARIC_LC,
                            lcl: LanguageKey.AMHARIC_LC)!
                      ].map((String package) {
                        return DropdownMenuItem<String>(
                            value: package,
                            child: Text(
                              package,
                              style: const TextStyle(
                                  color: CustomColor.TEXT_COLOR_GRAY_LIGHT,
                                  fontWeight: FontWeight.bold),
                            ));
                      }).toList(),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, RouteTo.CATEGORY_PREFERENCE);
                    },
                    title: Text(
                      StringRsr.get(LanguageKey.JOB_NOTIFICATION,
                          firstCap: true)!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: CustomColor.TEXT_COLOR_GRAY_LIGHT,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // BlocBuilder<ThemeBloc, ThemeState>(
                  //   builder: (context, state) {
                  //     if (state is ThemeState &&
                  //         state.themeData == appThemeData[AppData.Dark]) {
                  //       return ListTile(
                  //         title: Text(
                  //           "change Theme",
                  //           style: const TextStyle(
                  //               fontSize: 17, color: CustomColor.GRAY_LIGHT),
                  //         ),
                  //         trailing: Switch(
                  //           value: true,
                  //           onChanged: (value) {
                  //             isDark = value;
                  //             BlocProvider.of<ThemeBloc>(context)
                  //                 .add(ThemeChange(appData: AppData.Light));
                  //           },
                  //         ),
                  //         onTap: () {
                  //           //Navigator.pop(context); // Pops the navigation side drawer
                  //           // todo : help page here.
                  //         },
                  //       );
                  //     }
                  //     return ListTile(
                  //       title: Text(
                  //         "change Theme",
                  //         style: const TextStyle(
                  //             fontSize: 17, color: CustomColor.GRAY_LIGHT),
                  //       ),
                  //       trailing: Switch(
                  //         value: false,
                  //         onChanged: (value) {
                  //           BlocProvider.of<ThemeBloc>(context)
                  //               .add(ThemeChange(appData: AppData.Dark));
                  //         },
                  //       ),
                  //       onTap: () {
                  //         //Navigator.pop(context); // Pops the navigation side drawer
                  //         // todo : help page here.
                  //       },
                  //     );
                  //   },
                  // ),

                  const SizedBox(height: 0),
                  ListTile(
                    title: Text(
                      StringRsr.get(LanguageKey.MORE, firstCap: true)!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: CustomColor.GRAY_DARK,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  // ListTile(
                  //   onTap: () {},
                  //   title: Text(
                  //     "about us",
                  //     style: const TextStyle(
                  //         fontSize: 17,
                  //         color: CustomColor.GRAY_LIGHT,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, RouteTo.INFO_HELP);
                    },
                    title: Text(
                      StringRsr.get(LanguageKey.FAQL, firstCap: true)!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: CustomColor.TEXT_COLOR_GRAY_LIGHT,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteTo.INFO_CONTACT_US,
                      );
                    },
                    title: Text(
                      StringRsr.get(LanguageKey.CONTACT_US, firstCap: true)!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: CustomColor.TEXT_COLOR_GRAY_LIGHT,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      makeWebCall("https://bit.ly/kelem_privacy_policy");
                    },
                    title: Text(
                      StringRsr.get(LanguageKey.PRIVACY_POLICY,
                          firstCap: true)!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: CustomColor.TEXT_COLOR_GRAY_LIGHT,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      makeWebCall("https://bit.ly/kelem_licence_and_agreement");
                    },
                    title: Text(
                      StringRsr.get(LanguageKey.LICENCE_AND_AGREEMENTS,
                          firstCap: true)!,
                      style: const TextStyle(
                          fontSize: 17,
                          color: CustomColor.TEXT_COLOR_GRAY_LIGHT,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
