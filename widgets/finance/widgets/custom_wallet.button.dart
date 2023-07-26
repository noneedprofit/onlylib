import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomWalletButton extends StatelessWidget {
  const CustomWalletButton(this.title, this.iconData, {this.action, Key key})
      : super(key: key);

  final String title;
  final IconData iconData;
  final Function action;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Icon(
          iconData,
          size: 24,
          color: Utils.textColorByTheme(),
        ),
        UiSpacer.verticalSpace(space: 5),
        //
        title.text
            .color(Utils.textColorByTheme())
            .sm
            .maxLines(1)
            .ellipsis
            .make(),
      ],
      crossAlignment: CrossAxisAlignment.center,
    ).p8().onInkTap(action);
  }
}
