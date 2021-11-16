import 'package:flutter/material.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class TermsAndConditionsPage extends StatefulWidget {
  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
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

  EdgeInsets? containerMargin;
  double? titleFont;
  double? subTitleFont;
  double? questionFont;
  double? answerFont;

  setDeviceSpecificValues(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (height < 500) {
      containerMargin = EdgeInsets.symmetric(vertical: 21, horizontal: 15);
      titleFont = 21;
      subTitleFont = 11;
      questionFont = 14;
      answerFont = 12;
    } else if (height >= 500 && height <= 600) {
      // Nexus S & HVGA 3.2
      containerMargin = EdgeInsets.symmetric(vertical: 40, horizontal: 15);
      titleFont = 21;
      subTitleFont = 11;
      questionFont = 16;
      answerFont = 13;
    } else if (height > 600 && height <= 700) {
      // Nexus 5x
      containerMargin = EdgeInsets.symmetric(vertical: 70, horizontal: 20);
      titleFont = 27;
      subTitleFont = 13;
      questionFont = 18;
      answerFont = 14;
    } else {
      // Pixel 3 xL
      containerMargin = EdgeInsets.symmetric(vertical: 100, horizontal: 20);
      titleFont = 27;
      subTitleFont = 13;
      questionFont = 18;
      answerFont = 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    setDeviceSpecificValues(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: getAppBar2(context, "Help")),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: LightColor.background,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    StringRsr.get(LanguageKey.LICENCE_AND_AGREEMENTS,
                        firstCap: true)!,
                    style: TextStyle(
                        fontSize: titleFont, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    StringRsr.get(LanguageKey.FAQ, firstCap: true)!,
                    style: TextStyle(
                        fontSize: subTitleFont,
                        color: Color(AppTheme.gray99),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListView(
                  children: <Widget>[
                    Text(
                      StringRsr.get(LanguageKey.LICENCE_AND_AGREEMENTS_MESSAGE,
                          firstCap: true)!,
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: CustomColor.TEXT_DARK,
                      ),
                    ),
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
