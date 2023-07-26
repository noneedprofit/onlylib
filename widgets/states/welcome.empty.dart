import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fuodz/constants/home_screen.config.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/welcome/widgets/intro.welcome.view.dart';
import 'package:fuodz/views/pages/welcome/widgets/unauth.welcome.view.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/finance/custom_wallet_management.view.dart';
import 'package:fuodz/widgets/list_items/custom_vendor_type.grid_item.dart';
import 'package:fuodz/widgets/list_items/vendor_type.list_item.dart';
import 'package:fuodz/widgets/states/loading.shimmer.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyWelcome extends StatelessWidget {
  const EmptyWelcome({this.vm, Key key}) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Stack(
          children: [
            //welcome intro and loggedin account name
            WelcomeIntroView(vm),

            //finance section
            CustomVisibilty(
              visible: HomeScreenConfig.showWalletOnHomeScreen ?? true,
              child: AuthServices.authenticated()
                  ? CustomWalletManagementView()
                  : UnAuthWelcomeIntroView(),
            ).positioned(
              bottom: 0,
              left: 15,
              right: 15,
            ),
          ],
        ),

        //
        VStack(
          [
            //top banner
            CustomVisibilty(
              visible: HomeScreenConfig.showBannerOnHomeScreen &&
                  HomeScreenConfig.isBannerPositionTop,
              child: VStack(
                [
                  UiSpacer.verticalSpace(),
                  Banners(
                    null,
                    featured: true,
                  ).py12(),
                ],
              ),
            ),
            //
            VStack(
              [
                //list view
                CustomVisibilty(
                  visible: (HomeScreenConfig.isVendorTypeListingBoth &&
                          !vm.showGrid) ||
                      (!HomeScreenConfig.isVendorTypeListingBoth &&
                          HomeScreenConfig.isVendorTypeListingListView),
                  child: CustomListView(
                    noScrollPhysics: true,
                    dataSet: vm.vendorTypes,
                    isLoading: vm.isBusy,
                    loadingWidget: LoadingShimmer().px20(),
                    itemBuilder: (context, index) {
                      final vendorType = vm.vendorTypes[index];
                      return VendorTypeListItem(
                        vendorType,
                        onPressed: () {
                          NavigationService.pageSelected(vendorType,
                              context: context);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => UiSpacer.emptySpace(),
                  ),
                ),
                //gridview
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      vm.showGrid &&
                      vm.isBusy,
                  child: LoadingShimmer().px20().centered(),
                ),
                CustomVisibilty(
                  visible: HomeScreenConfig.isVendorTypeListingGridView &&
                      vm.showGrid &&
                      !vm.isBusy,
                  child: AnimationLimiter(
                    child: MasonryGrid(
                      column: HomeScreenConfig.vendorTypePerRow ?? 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(
                        vm.vendorTypes.length ?? 0,
                        (index) {
                          final vendorType = vm.vendorTypes[index];
                          return CustomVendorTypeGridItem(
                            vendorType,
                            onPressed: () {
                              NavigationService.pageSelected(vendorType,
                                  context: context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ).p20(),

            //botton banner
            CustomVisibilty(
              visible: HomeScreenConfig.showBannerOnHomeScreen &&
                  !HomeScreenConfig.isBannerPositionTop,
              child: Banners(
                null,
                featured: true,
              ).py12().pOnly(bottom: context.percentHeight * 10),
            ),
          ],
        ),
      ],
      // key: vm.genKey,
    ).scrollVertical();
  }
}
