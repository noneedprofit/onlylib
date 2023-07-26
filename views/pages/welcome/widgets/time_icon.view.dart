import 'package:flutter/material.dart';
import 'package:fuodz/constants/custom_home_ui.settings.dart';
import 'package:velocity_x/velocity_x.dart';

class TimeIconView extends StatelessWidget {
  const TimeIconView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      CustomHomeUISettings.timeIconData(),
      size: 40,
      color: Colors.yellow.shade700,
    ).p12();
  }
}
