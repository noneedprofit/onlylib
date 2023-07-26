import 'dart:io';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_upgrade_settings.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/views/pages/profile/profile.page.dart';
import 'package:fuodz/view_models/home.vm.dart';
import 'package:fuodz/views/pages/search/search.page.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';

import 'order/orders.page.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(context);
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        LocationService.prepareLocationListener();
        vm?.initialise();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => vm,
        builder: (context, model, child) {
          return BasePage(
            body: UpgradeAlert(
              upgrader: Upgrader(
                showIgnore: !AppUpgradeSettings.forceUpgrade(),
                shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: Stack(
                children: [
                  VStack(
                    [
                      PageView(
                        controller: model.pageViewController,
                        onPageChanged: model.onPageChanged,
                        children: [
                          model.homeView,
                          OrdersPage(),
                          SearchPage(
                            search: Search(
                              showType: 4,
                            ),
                            showCancel: false,
                          ),
                          ProfilePage(),
                        ],
                      ).expand(),
                      //bottombar
                      VxBox(
                        child: SafeArea(
                          top: false,
                          child: GNav(
                            // gap: 8,
                            activeColor: AppColor.primaryColorDark,
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            iconSize: 26,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            duration: Duration(milliseconds: 250),
                            // tabBackgroundColor: Theme.of(context).colorScheme.secondary,
                            tabs: [
                              GButton(
                                icon: FlutterIcons.home_ant,
                                // text: 'Home'.tr(),
                              ),
                              GButton(
                                icon: FlutterIcons.inbox_ant,
                                // text: 'Orders'.tr(),
                              ),
                              GButton(
                                icon: FlutterIcons.search_fea,
                                // text: 'Search'.tr(),
                              ),
                              GButton(
                                icon: FlutterIcons.menu_fea,
                                // text: 'More'.tr(),
                              ),
                            ],
                            selectedIndex: model.currentIndex,
                            onTabChange: model.onTabChange,
                          ),
                        ),
                      )
                          .p16
                          .shadow
                          .color(Theme.of(context)
                              .bottomSheetTheme
                              .backgroundColor)
                          .make(),
                    ],
                  ),

                  //cart button
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Icon(
                      FlutterIcons.shopping_cart_faw,
                      color: Colors.white,
                      size: 36,
                    )
                        .badge(
                          position: Utils.isArabic
                              ? VxBadgePosition.leftTop
                              : VxBadgePosition.rightTop,
                          count: model.totalCartItems,
                          color: Colors.white,
                          textStyle: context.textTheme.bodyText1?.copyWith(
                            color: AppColor.primaryColor,
                            fontSize: 10,
                          ),
                        )
                        .p(10)
                        .box
                        .color(AppColor.primaryColorDark)
                        .roundedFull
                        .border(width: 2.5, color: Colors.white)
                        .make()
                        .onTap(model.openCart)
                        .centered(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
