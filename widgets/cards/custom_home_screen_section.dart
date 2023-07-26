import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomHomeScreenSection extends StatelessWidget {
  const CustomHomeScreenSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //background
        CustomImage(
          imageUrl:
              "https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1813&q=80",
        ).wFull(context).h(280),
        //app logo
        Image.asset(
          AppImages.auth,
          width: 40,
          height: 40,
        ).positioned(
          right: 30,
          top: kToolbarHeight,
        ),

        //intro
        VStack(
          [
            //icon
            CustomImage(
              imageUrl: "https://cdn-icons-png.flaticon.com/512/979/979585.png",
            ).wh(32, 32).px(20),
            UiSpacer.vSpace(5),
            //name
            "Good afternoon NAME"
                .text
                .semiBold
                .minFontSize(23)
                .size(23)
                .white
                .maxLines(1)
                .ellipsis
                .make(),
            //text
            "How can I help you today?"
                .text
                .white
                .medium
                .lg
                .maxLines(1)
                .ellipsis
                .make(),
          ],
        ).positioned(
          top: 120,
          left: 30,
          right: 30,
        ),
      ],
    );
  }
}
