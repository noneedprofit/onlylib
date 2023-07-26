import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/custom_home_ui.settings.dart';
import 'package:fuodz/models/custom_home_screen.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/welcome/widgets/time_icon.view.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomeIntroView extends StatefulWidget {
  WelcomeIntroView(
    this.vm, {
    Key key,
  }) : super(key: key);

  final WelcomeViewModel vm;
  @override
  State<WelcomeIntroView> createState() => _WelcomeIntroViewState();
}

class _WelcomeIntroViewState extends State<WelcomeIntroView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomHomeScreen>(
        future: CustomHomeUISettings.currentHomeScreen(),
        builder: (context, snapshot) {
          return Stack(
            children: [
              //bg image
              VStack(
                [
                  //
                  Visibility(
                    visible: !snapshot.hasData,
                    child: UiSpacer.emptySpace(),
                  ),
                  //
                  Visibility(
                    visible: snapshot.hasData,
                    child: CustomImage(
                      imageUrl: snapshot?.data?.photo,
                      width: double.infinity,
                      height: 220,
                    ),
                  ),
                ],
              ),

              //logo
              Positioned(
                top: kToolbarHeight - 15,
                right: 20,
                child: Image.asset(
                  AppImages.appLogo,
                  width: 50,
                  height: 50,
                ),
              ),
              //title/description
              Positioned(
                bottom: 70,
                left: 30,
                right: 30,
                child: StreamBuilder(
                  stream: AuthServices.listenToAuthState(),
                  builder: (ctx, authSnapshot) {
                    //
                    if (authSnapshot.hasData) {
                      return FutureBuilder<User>(
                        future: AuthServices.getCurrentUser(),
                        builder: (ctx, userSnapshot) {
                          String introText = "${snapshot?.data?.title}";
                          String fullIntroText =
                              "${snapshot?.data?.description}";

                          //
                          if (userSnapshot.hasData) {
                            introText = CustomHomeUISettings.clearedScreenName(
                              introText,
                              replace: "${userSnapshot.data.name}",
                            );
                            //
                            fullIntroText =
                                CustomHomeUISettings.clearedScreenName(
                              fullIntroText,
                              replace: "${userSnapshot.data.name}",
                            );
                          }
                          //
                          return VStack(
                            [
                              //time icon
                              TimeIconView(),
                              //
                              introText.text.white.bold.xl2
                                  .shadow(0.5, 0.5, 5, AppColor.primaryColor)
                                  .make(),
                              //description
                              fullIntroText.text.white.lg
                                  .shadow(0.5, 0.5, 5, AppColor.primaryColor)
                                  .make(),
                            ],
                          );
                        },
                      );
                    }

                    //unauth
                    return VStack(
                      [
                        //time icon
                        TimeIconView(),
                        CustomHomeUISettings.clearedScreenName(
                                "${snapshot?.data?.title}")
                            .tr()
                            .text
                            .white
                            .bold
                            .xl2
                            .shadow(0.5, 0.5, 5, AppColor.primaryColor)
                            .make(),
                        //description
                        CustomHomeUISettings.clearedScreenName(
                                "${snapshot?.data?.description}")
                            .tr()
                            .text
                            .white
                            .lg
                            .shadow(0.5, 0.5, 5, AppColor.primaryColor)
                            .make(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ).h(220);
        }).pOnly(bottom: 100);
  }
}
