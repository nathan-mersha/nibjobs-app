import 'package:flutter/material.dart';

import 'light_color.dart';

class AppTheme {
  const AppTheme();
  static const String warm = "warm";
  static const String cool = "cool";
  static const String dark = "dark";
  static const String small = "small";
  static const String medium = "medium";
  static const String large = "large";
  static String currentTheme = warm;
  static String fontSizeGlobal = small;
  static const violet = 0xff6100b5;
  static const yellow = 0xffffca00;
  static const pink = 0xffaa0088;
  static const white = 0xffffffff;
  static const darkDarkGray = 0xff333333;
  static const darkGray = 0xff1a1a1a;
  static const gray = 0xff808080;
  static const fafafa = 0xfffafafa;
  static const veryLightGray = 0xffe8e8e8;
  static const darkBlue = 0xff1d005c;
  static const gray99 = 0xff999999;
  static const gray66 = 0xff666666;
  static const grayfofo = 0xfff0f0f0;
  static const grayb3b3 = 0xffb3b3b3;
  static const darkPink = 0xffA00074;

  static const titleDarkBlue = 0xff1d005c;
  static const bbNavColor = 0xff666666;
  static const lightGray = 0xffcccccc;

  static const backgroundColor = 0xfff5f5f5;
  static const sideDrawerHeaderColor = 0xff999999;
  static const appbarTitle = 0xffb3b3b3;

  static const double popupOpacity = 0.6;
  // Dropdown style key values def begins.
  static const String CONTAINER_PADDING = "containerPadding";
  static const String CONTAINER_HEIGHT = "containerHeight";
  static const String CONTAINER_DECORATION = "containerDecoration";
  static const String DROPDOWN_TEXT_STYLE = "dropDownconst TextStyle";
  static const String DROPDOWN_ICON_SIZE = "dropDownIconSize";
  static const String DROPDOWN_UNDER_LINE = "dropDownUnderLine";
  static const String DROPDOWN_ICON = "dropDownIcon";
  static const String WARNING_ICON = "warningIcon";
  static const String HINT_TEXT_STYLE = "hintconst TextStyle";
  static ThemeData lightTheme = ThemeData(
      backgroundColor: LightColor.background,
      primaryColor: LightColor.background,
      cardTheme: const CardTheme(color: LightColor.background),
      textTheme: const TextTheme(bodyText1: TextStyle(color: LightColor.black)),
      iconTheme: const IconThemeData(color: LightColor.iconColor),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.lightGrey,
      primaryTextTheme: const TextTheme(
          bodyText1: TextStyle(color: LightColor.titleTextColor)));

  static const TextStyle titleStyle =
      TextStyle(color: LightColor.titleTextColor, fontSize: 16);
  static const TextStyle subTitleStyle =
      TextStyle(color: LightColor.subTitleTextColor, fontSize: 12);

  static const TextStyle h1Style =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle h2Style = TextStyle(fontSize: 22);
  static const TextStyle h3Style = TextStyle(fontSize: 20);
  static const TextStyle h4Style = TextStyle(fontSize: 18);
  static const TextStyle h5Style = TextStyle(fontSize: 16);
  static const TextStyle h6Style = TextStyle(fontSize: 14);

  static List<BoxShadow> shadow = <BoxShadow>[
    const BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 20,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static InputDecoration getDecorationTFF(String hint,
      {enableLabel: false, borderSideThickness: 2.0, icon, errorText}) {
    if (enableLabel) {
      return InputDecoration(
        suffixIcon: icon ?? Container(),
        errorStyle: const TextStyle(fontSize: 12),
        errorText: errorText,
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: const Color(AppTheme.veryLightGray),
              width: borderSideThickness),
        ),
        // focusedBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: Color(AppTheme.gray), width: 2)),
        // border: OutlineInputBorder(),
        alignLabelWithHint: true,
        hintText: hint,
        labelText: hint,
        labelStyle: const TextStyle(color: Color(AppTheme.lightGray)),
        hintStyle: const TextStyle(color: Color(AppTheme.lightGray)),
      );
    } else {
      return InputDecoration(
        suffixIcon: icon ?? Container(),
        contentPadding: const EdgeInsets.all(13),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color(AppTheme.veryLightGray), width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(AppTheme.gray), width: 2)),
        border: const OutlineInputBorder(),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(AppTheme.lightGray)),
      );
    }
  }

  static TextStyle getTextStyleTFF(context, {color}) {
    double height = MediaQuery.of(context).size.height;
    double fontSize;
    if (height < 600) {
      // Nexus S & HVGA 3.2
      fontSize = 14;
    } else if (height > 600 && height < 700) {
      // Nexus 5x
      fontSize = 16;
    } else {
      // Pixel 3 xL
      fontSize = 18;
    }

    return TextStyle(
      color: color ?? const Color(AppTheme.darkGray),
      fontSize: fontSize, //
    );
  }
}

double jobViewH(BuildContext context) {
  double numberSize = 0;
  if (AppTheme.fullWidth(context) < 600) {
    numberSize = .7;
  } else if (AppTheme.fullWidth(context) <= 750) {
    numberSize = .35;
  } else if (AppTheme.fullWidth(context) < 850) {
    numberSize = .36;
  } else if (AppTheme.fullWidth(context) < 1000) {
    numberSize = .37;
  } else if (AppTheme.fullWidth(context) > 1000) {
    numberSize = .20;
  }

  return numberSize;
}
