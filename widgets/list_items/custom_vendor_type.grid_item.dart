import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomVendorTypeGridItem extends StatelessWidget {
  const CustomVendorTypeGridItem(this.vendorType, {this.onPressed, Key key})
      : super(key: key);

  final VendorType vendorType;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: vendorType.id,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: InkWell(
            onTap: onPressed,
            child: VStack(
              [
                //image + details
                Visibility(
                  visible: !AppStrings.showVendorTypeImageOnly,
                  child: VStack(
                    [
                      //
                      CustomImage(
                        imageUrl: vendorType.logo,
                        boxFit: BoxFit.contain,
                        width: double.infinity,
                        height: Vx.dp40 * 1.1,
                      ).p8().centered(),
                      //
                      VStack(
                        [
                          vendorType.name.text.white.center.sm.semiBold
                              .minFontSize(9)
                              .makeCentered(),
                          Visibility(
                            visible: vendorType.description != null &&
                                vendorType.description.isNotEmptyAndNotNull,
                            child: vendorType
                                .description.text.center.white.center.xs
                                .makeCentered(),
                          ),
                        ],
                      ),
                    ],
                  ).p12().centered(),
                ),

                //image only
                Visibility(
                  visible: AppStrings.showVendorTypeImageOnly,
                  child: CustomImage(
                    imageUrl: vendorType.logo,
                    width: context.percentWidth * 100,
                    height: 85,
                    boxFit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          )
              .box
              .clip(Clip.antiAlias)
              .withRounded(value: 15)
              .outerShadow
              .color(Vx.hexToColor(vendorType.color))
              .make(),
        ),
      ),
    );
  }
}
