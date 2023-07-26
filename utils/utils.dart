import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class Utils {
  static bool get isArabic => translator.activeLocale.languageCode == "ar";

  static bool get currencyLeftSided {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      final currencylOCATION = uiConfig["currency"]["location"] ?? 'left';
      return currencylOCATION.toLowerCase() == "left";
    } else {
      return true;
    }
  }

  static bool isDark(Color color) {
    return ColorUtils.calculateRelativeLuminance(
            color.red, color.green, color.blue) <
        0.5;
  }

  static bool isPrimaryColorDark([Color mColor]) {
    final color = mColor ?? AppColor.primaryColor;
    return ColorUtils.calculateRelativeLuminance(
            color.red, color.green, color.blue) <
        0.5;
  }

  static Color textColorByTheme() {
    return isPrimaryColorDark() ? Colors.white : Colors.black;
  }

  static Color textColorByColor(Color color) {
    return isPrimaryColorDark(color) ? Colors.white : Colors.black;
  }

//CUSTOMIZATION
  static int daysBetween([DateTime from, DateTime to]) {
    if (from == null) {
      from = DateTime.now();
    }
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static setJiffyLocale() async {
    String cLocale = translator.activeLocale.languageCode;
    List<String> supportedLocales = Jiffy.getAllAvailableLocales();
    if (supportedLocales.contains(cLocale)) {
      await Jiffy.locale(translator.activeLocale.languageCode);
    } else {
      await Jiffy.locale("en");
    }
  }
}
