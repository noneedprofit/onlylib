import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/custom_app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/coupons.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/states/loading_state.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:lottie/lottie.dart';
import 'package:ticket_widget/ticket_widget.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CouponViewModel>.reactive(
        viewModelBuilder: () => CouponViewModel(context),
        onModelReady: (vm) => vm.initialise(),
        builder: (ctx, vm, child) {
          final imgSize = context.percentWidth * 30;
          final imgSizeSm = context.percentWidth * 20;
          final imgSizeXs = context.percentWidth * 10;
          final btnColor = Colors.red.shade600;
          //
          return BasePage(
            isLoading: vm.isBusy,
            title: "",
            showAppBar: true,
            showLeadingAction: true,
            backgroundColor: AppColor.primaryColor,
            body: VStack(
              [
                // COUPON IMAGE
                VStack(
                  [
                    Lottie.asset(CustomAppImages.suprise)
                        .wh(imgSize, imgSize)
                        .centered(),
                    Lottie.asset(CustomAppImages.giftbox)
                        .wh(imgSizeSm, imgSizeSm)
                        .centered(),
                  ],
                ).centered().p20(),
                //
                VStack(
                  [
                    "Coupons"
                        .tr()
                        .text
                        .semiBold
                        .xl2
                        .color(Utils.textColorByColor(AppColor.primaryColor))
                        .make(),
                    "Our list of available coupons"
                        .tr()
                        .text
                        .medium
                        .lg
                        .color(Utils.textColorByColor(AppColor.primaryColor))
                        .make(),
                  ],
                ).p20(),

                //coupons
                LoadingIndicator(
                  loading: vm.isBusy,
                  child: VStack(
                    [
                      //main coupon
                      VStack(
                        [
                          HStack(
                            [
                              "Promotions"
                                  .tr()
                                  .text
                                  .semiBold
                                  .black
                                  .make()
                                  .expand(),
                              vm.mainCoupon != null
                                  ? ("Validity untill".tr() +
                                          " ${Utils.daysBetween(null, vm.mainCoupon?.expiresOn)}" +
                                          "days".tr())
                                      .text
                                      .sm
                                      .semiBold
                                      .make()
                                  : UiSpacer.emptySpace(),
                            ],
                          ),
                          //main coupon details
                          HStack(
                            [
                              //img
                              CustomImage(
                                imageUrl: vm.mainCoupon?.photo,
                              ).wh(imgSizeXs, imgSizeXs),
                              //text
                              "${vm.mainCoupon?.description}"
                                  .text
                                  .sm
                                  .black
                                  .make()
                                  .px12()
                                  .expand(),
                              //other info
                              VStack(
                                [
                                  CustomButton(
                                    color: btnColor,
                                    title: "Use Coupon".tr(),
                                    titleStyle:
                                        context.textTheme.bodySmall.copyWith(
                                      fontSize: 12,
                                      color: Utils.textColorByColor(btnColor),
                                    ),
                                    height: 24,
                                    onPressed: () {
                                      vm.copyCoupon(vm.mainCoupon);
                                    },
                                  ),
                                  UiSpacer.vSpace(5),
                                  "${vm.mainCoupon?.code}"
                                      .text
                                      .capitalize
                                      .bold
                                      .red400
                                      .makeCentered(),
                                ],
                                crossAlignment: CrossAxisAlignment.center,
                              ),
                            ],
                          ).py12(),
                        ],
                      ).p12(),
                      //other coupons list
                      CustomListView(
                        noScrollPhysics: true,
                        dataSet: vm.coupons,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        itemBuilder: (ctx, index) {
                          final coupon = vm.coupons[index];
                          //
                          return FittedBox(
                            child: TicketWidget(
                              width: context.percentWidth * 90,
                              height: 90,
                              isCornerRounded: true,
                              padding: EdgeInsets.only(left: 30),
                              child: HStack(
                                [
                                  //img
                                  CustomImage(
                                    imageUrl: coupon.photo,
                                  ).wh(imgSizeXs, imgSizeXs),
                                  //text
                                  "${coupon.description}"
                                      .text
                                      .black
                                      .maxLines(3)
                                      .ellipsis
                                      .sm
                                      .make()
                                      .px8()
                                      .expand(),
                                  //other info
                                  VStack(
                                    [
                                      "${coupon.code}"
                                          .text
                                          .capitalize
                                          .lg
                                          .bold
                                          .red400
                                          .makeCentered(),
                                      UiSpacer.vSpace(5),
                                      FittedBox(
                                        child: SizedBox(
                                          height: 22,
                                          width: 95,
                                          child: CustomButton(
                                            color: btnColor,
                                            title: "Use Coupon".tr(),
                                            titleStyle: context
                                                .textTheme.bodySmall
                                                .copyWith(
                                              fontSize: 10,
                                              color: Utils.textColorByColor(
                                                  btnColor),
                                            ),
                                            onPressed: () {
                                              vm.copyCoupon(coupon);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                    crossAlignment: CrossAxisAlignment.center,
                                  )
                                      .h(90)
                                      .py12()
                                      .px16()
                                      .pOnly(right: 16)
                                      .box
                                      .rightRounded(value: 10)
                                      .color(btnColor.withOpacity(0.15))
                                      .make(),
                                ],
                              ),
                            ),
                          );
                        },
                      ).box.color(btnColor.withOpacity(0.03)).make(),
                    ],
                  ).box.white.roundedSM.make().px20().pOnly(bottom: 20),
                )
              ],
            ).scrollVertical(),
          );
        });
  }
}
