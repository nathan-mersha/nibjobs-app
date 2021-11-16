import 'package:flutter/material.dart';
import 'package:nibjobs/rsr/locale/lang/en.dart';
import 'package:nibjobs/rsr/locale/lang/et_am.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';

class StringRsr {
  static Map<String?, String?> languageMapping = {
    StringRsr.get(LanguageKey.AMHARIC_LC, lcl: LanguageKey.AMHARIC_LC):
        LanguageKey.AMHARIC_LC,
    StringRsr.get(LanguageKey.ENGLISH_LC, lcl: LanguageKey.ENGLISH_LC):
        LanguageKey.ENGLISH_LC,
    // todo : Add more languages here.
  };

  // Default locale setup
  static String locale = LanguageKey.ENGLISH_LC;

  /// default lang

  static final Map<String, Map<String, String>> _localizedValues = {
    LanguageKey.ENGLISH_LC: EN.val,
    LanguageKey.AMHARIC_LC: ET_AM.val,
  };
  static String? get(key, {firstCap = false, lcl}) {
    String localeVal = lcl ?? locale;

    String val = _localizedValues[localeVal]![key]!;

    if (firstCap) {
      return val == ""
          ? '${_localizedValues[LanguageKey.ENGLISH_LC]![key]![0].toUpperCase()}${_localizedValues[LanguageKey.ENGLISH_LC]![key]!.substring(1)}'
          : '${val[0].toUpperCase()}${val.substring(1)}';
    } else {
      return val == null || val == ""
          ? _localizedValues[LanguageKey.ENGLISH_LC]![key]
          : val;
    }
  }

  static StringRsr? of(BuildContext context) {
    return Localizations.of<StringRsr>(context, StringRsr);
  }
}
