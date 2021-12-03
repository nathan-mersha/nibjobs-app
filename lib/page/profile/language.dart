import 'package:flutter/material.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';

class LanguagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LanguagePageState();
  }
}

class _LanguagePageState extends State<LanguagePage> {
  // LocalPreference aSP = GetLocalPreferenceInstance.localPreference;
  HSharedPreference localPreference = GetHSPInstance.hSharedPreference;
  static String defaultLanguage =
      StringRsr.get(LanguageKey.ENGLISH_LC)!; // Default language is English
  String selectedLanguage = defaultLanguage;
  String proceedButtonTxt = StringRsr.get(LanguageKey.PROCEED)!;

  setSelectedLanguage(String newSelectedLanguage) {
    setState(() {
      selectedLanguage = newSelectedLanguage;
      String locale = StringRsr.languageMapping[selectedLanguage]!;
      proceedButtonTxt = StringRsr.get(LanguageKey.PROCEED, lcl: locale)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Image.asset(
                    //   "assets/images/icon_primary_color.png",
                    //   width: 60,
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // const Text(
                    //   "ሰላም",
                    //   style: TextStyle(
                    //       fontSize: 28, color: CustomColor.GRAY_LIGHT),
                    // ),
                    // const Text(
                    //   "Hello there,",
                    //   style: TextStyle(fontSize: 28, color: CustomColor.GRAY),
                    // ),
                    const Spacer(),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.white,
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/select_language.png",
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: const [
                                Text(
                                  "እባክዎ ቋንቋ ይምረጡ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: CustomColor.GRAY_DARK),
                                ),
                                Text(
                                  "please select a language",
                                  style: TextStyle(
                                      fontSize: 16, color: CustomColor.GRAY),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            DropdownButton<String>(
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
                                    value: package, child: Text(package));
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                              child: ElevatedButton(
                                // style: ElevatedButton.styleFrom(
                                //   primary: Theme.of(context).primaryColorDark,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(30.0),
                                //   ),
                                // ),
                                child: Text(
                                  proceedButtonTxt,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                onPressed: () async {
                                  // todo : set first time flag to false
                                  // todo : navigate to welcome page

                                  String locale = StringRsr
                                      .languageMapping[selectedLanguage]!;
                                  if (locale != null) {
                                    await localPreference
                                        .set(HSharedPreference.LOCALE, locale)
                                        .then((value) async {
                                      StringRsr.locale = locale;
                                      await localPreference.set(
                                          HSharedPreference.KEY_FIRST_TIME,
                                          true);
                                      Navigator.pushReplacementNamed(
                                          context,
                                          RouteTo
                                              .INFO_WELCOME); //HRoutes.WELCOME
                                    });
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
