import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class UnAuthWelcomeIntroView extends StatelessWidget {
  UnAuthWelcomeIntroView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Hey there!".tr().text.semiBold.make(),
        "Log in or create an account for a faster ordering experience"
            .tr()
            .text
            .italic
            .sm
            .light
            .make(),
        UiSpacer.divider().py8(),
        //buttons
        CustomButton(
          title: "Login".tr(),
          shapeRadius: 24,
          onPressed: () {
            context.navigator.pushNamed(AppRoutes.loginRoute);
          },
        ).w(context.percentWidth * (!Utils.isArabic ? 32 : 50)).centered()
      ],
    )
        .p12()
        .box
        .rounded
        .outerShadowXl
        .color(context.backgroundColor)
        .make()
        .wFull(context);
  }
}
