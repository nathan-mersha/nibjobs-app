import 'package:flutter/material.dart';
import 'package:nibjobs/consetance/enums.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';

class MainTheme {
  // static ThemeData getTheme() {
  //   return ThemeData(
  //       fontFamily: "Nunito",
  //       primaryColor: Colors.deepOrangeAccent,
  //       backgroundColor: Colors.white,
  //       buttonTheme: ButtonThemeData(buttonColor: Colors.deepOrangeAccent, textTheme: ButtonTextTheme.primary));
  // }

  static EdgeInsets getPagePadding() {
    return const EdgeInsets.only(top: 10, bottom: 4, right: 10, left: 10);
  }
}

final appThemeData = {
  AppData.Light: ThemeData(
      fontFamily: StringRsr.locale == "en" ? "Sofia" : "Noto",
      backgroundColor: LightColor.lightGrey,
      primaryColor: CustomColor.PRIM_DARK,
      primaryColorDark: CustomColor.RAD_DARK,
      hoverColor: CustomColor.PRIM_DARK,
      appBarTheme: const AppBarTheme(
        color: LightColor.lightGrey,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            color: CustomColor.PRIM_DARK,
          ),
          primary: CustomColor.RAD_DARK,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      cardTheme: const CardTheme(color: LightColor.background),
      unselectedWidgetColor: CustomColor.GRAY,
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: CustomColor.TEXT_COLOR_GRAY),
        bodyText2: TextStyle(color: CustomColor.TEXT_COLOR_GRAY_LIGHT),
        subtitle1: TextStyle(color: CustomColor.TEXT_COLOR_GRAY),
        subtitle2: TextStyle(color: CustomColor.TEXT_COLOR_GRAY_LIGHT),
        headline6: TextStyle(color: CustomColor.TEXT_COLOR_GRAY),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xff808080),
      ),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.lightGrey,
      primaryTextTheme:
          const TextTheme(bodyText1: TextStyle(color: CustomColor.GRAY_LIGHT))),
  AppData.Dark: ThemeData(
    fontFamily: "Sofia",
    // primaryColor: CustomColor.RAD_DARK,
    // primaryColorDark: CustomColor.PRIM_DARK,
    // backgroundColor: Colors.black,
    // hoverColor: CustomColor.PRIM_DARK,
    // appBarTheme: const AppBarTheme(
    //   color: Colors.black,
    // ),
    // cardTheme: const CardTheme(color: CustomColor.RAD_DARK),

    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: CustomColor.PRIM_DARK,
        textStyle: const TextStyle(
          color: Colors.black,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),

    // textTheme: const TextTheme(
    //   bodyText1: TextStyle(color: CustomColor.TEXT_COLOR_GRAY),
    //   bodyText2: TextStyle(color: CustomColor.GRAY_LIGHT),
    //   subtitle1: TextStyle(color: CustomColor.TEXT_COLOR_GRAY_LIGHT),
    //   subtitle2: TextStyle(color: CustomColor.TEXT_COLOR_GRAY),
    //   headline6: TextStyle(color: CustomColor.TEXT_COLOR_GRAY),
    // ),
    // bottomAppBarColor: LightColor.background,
    // dividerColor: Colors.black,
    // buttonTheme: const ButtonThemeData(
    //     buttonColor: Colors.deepOrangeAccent,
    //     textTheme: ButtonTextTheme.primary)
  ),
};
