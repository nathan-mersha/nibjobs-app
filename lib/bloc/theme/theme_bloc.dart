import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/consetance/enums.dart';
import 'package:nibjobs/rsr/theme/main_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(String themeState)
      : super(ThemeState(
            themeData: appThemeData[themeState == ""
                ? AppData.Light
                : themeState == "AppData.Light"
                    ? AppData.Light
                    : AppData.Dark]!));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChange) {
      yield ThemeState(themeData: appThemeData[event.appData]!);
    }
  }
}
