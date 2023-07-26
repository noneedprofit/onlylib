import 'dart:convert';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/custom_home_screen.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:intl/intl.dart';

class CustomHomeUISettings {
  static bool showSection(String section) {
    if (AppStrings.env('ui') == null ||
        AppStrings.env('ui')["home"] == null ||
        AppStrings.env('ui')["home"][section] == null) {
      return true;
    }
    return AppStrings.env('ui')["home"][section] == "1" ||
        AppStrings.env('ui')["home"][section] == 1;
  }

  //Vendor UI section
  static Future<CustomHomeScreen> currentHomeScreen() async {
    final screens = await homeScreens();
    CustomHomeScreen foundScreen = screens.firstWhere((e) {
      //
      try {
        return isValidTimeRange(e.startTime, e.endTime);
      } catch (error) {
        return false;
      }
    }, orElse: () => screens.first);
    return foundScreen;
  }

  static Future<List<CustomHomeScreen>> homeScreens() async {
    await getScreensFromLocalStorage();
    return appScreensObject != null
        ? (appScreensObject as List)
            .map((e) => CustomHomeScreen.fromJson(e))
            .toList()
        : [];
  }

  static String customHomeScreenTag = "custom_home_screens";
//saving
  static Future<bool> saveScreensToLocalStorage(String screensMap) async {
    return await LocalStorageService.prefs
        .setString(customHomeScreenTag, screensMap);
  }

  static dynamic appScreensObject;
  static Future<void> getScreensFromLocalStorage() async {
    appScreensObject = LocalStorageService.prefs.getString(customHomeScreenTag);
    if (appScreensObject != null) {
      appScreensObject = jsonDecode(appScreensObject);
    }
  }

  //
  static bool isValidTimeRange(String startTime, String endTime) {
    final today = new DateFormat("yyyy-MM-dd", "en").format(DateTime.now());
    DateTime startDate = DateTime.parse(today + " " + startTime + "z");
    DateTime endDate = DateTime.parse(today + " " + endTime + "z");
    DateTime now = DateTime.now();
    final result = startDate.isBefore(now) && endDate.isAfter(now);
    return result;
  }

  static String clearedScreenName(String value, {String replace = ""}) {
    return value.replaceAll("**name**", replace);
  }

  static IconData timeIconData() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return FlutterIcons.sunrise_fea;
    }
    if (hour < 17) {
      return FlutterIcons.weather_sunset_mco;
    }
    return FlutterIcons.weather_night_mco;
  }
}
