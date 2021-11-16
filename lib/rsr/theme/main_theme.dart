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
      backgroundColor: LightColor.background,
      primaryColor: CustomColor.PRIM_DARK,
      cardTheme: const CardTheme(color: LightColor.background),
      textTheme:
          const TextTheme(bodyText1: TextStyle(color: CustomColor.GRAY_LIGHT)),
      iconTheme: const IconThemeData(color: CustomColor.GRAY_LIGHT),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.lightGrey,
      primaryTextTheme:
          const TextTheme(bodyText1: TextStyle(color: CustomColor.GRAY_LIGHT))),
  AppData.Dark: ThemeData(
      fontFamily: "Sofia",
      primaryColor: const Color(0xff9c0044),
      backgroundColor: Colors.black,
      cardTheme: const CardTheme(color: LightColor.background),
      brightness: Brightness.dark,
      iconTheme: const IconThemeData(color: CustomColor.GRAY_LIGHT),
      textTheme:
          const TextTheme(bodyText1: TextStyle(color: CustomColor.GRAY_LIGHT)),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.lightGrey,
      buttonTheme: const ButtonThemeData(
          buttonColor: Colors.deepOrangeAccent,
          textTheme: ButtonTextTheme.primary)),
};
