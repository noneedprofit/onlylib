import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/wallet.vm.dart';
import 'package:fuodz/views/pages/wallet/wallet.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:fuodz/widgets/finance/widgets/custom_wallet.button.dart';
import 'package:fuodz/widgets/states/loading_state.view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:timelines/timelines.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomWalletManagementView extends StatefulWidget {
  const CustomWalletManagementView({this.viewmodel, Key key}) : super(key: key);

  final WalletViewModel viewmodel;

  @override
  State<CustomWalletManagementView> createState() =>
      _CustomWalletManagementViewState();
}

class _CustomWalletManagementViewState extends State<CustomWalletManagementView>
    with WidgetsBindingObserver {
  WalletViewModel mViewmodel;
  @override
  void initState() {
    super.initState();

    mViewmodel = widget.viewmodel;
    mViewmodel ??= WalletViewModel(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      mViewmodel.initialise();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding?.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mViewmodel != null) {
      mViewmodel.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletViewModel>.reactive(
      viewModelBuilder: () => mViewmodel,
      disposeViewModel: widget.viewmodel == null,
      builder: (context, vm, child) {
        return FutureBuilder<User>(
          initialData: null,
          future: AuthServices.getCurrentUser(),
          builder: (ctx, snapshot) {
            //
            if (!snapshot.hasData) {
              return UiSpacer.emptySpace();
            }
            //loading
            if (vm.isBusy) {
              return BusyIndicator().centered().p12();
            }
            //view
            return VStack(
              [
                //
                HStack(
                  [
                    "Wallet".tr().text.lg.semiBold.make(),
                    DotIndicator(
                      color: Colors.grey.shade700,
                      size: 8,
                    ).p4(),
                    "${Jiffy(vm.wallet.updatedAt).format('hh:mm a dd, MMM y')}"
                        .tr()
                        .text
                        .sm
                        .make()
                        .px4()
                        .centered()
                        .expand(),
                    DotIndicator(
                      color: Colors.grey.shade700,
                      size: 8,
                    ).p4(),
                    "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet.balance : 0.00}"
                        .currencyFormat()
                        .text
                        .sm
                        .bold
                        .make(),
                    Icon(
                      !Utils.isArabic
                          ? FlutterIcons.chevron_right_evi
                          : FlutterIcons.chevron_left_evi,
                    ),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                  alignment: MainAxisAlignment.center,
                ).onInkTap(
                  () {
                    //open wallet page
                    context.nextPage(WalletPage());
                  },
                ),

                UiSpacer.divider().py8(),
                //buttons
                Visibility(
                  visible: !vm.isBusy,
                  child: HStack(
                    [
                      //home button
                      CustomWalletButton(
                        "Home".tr(),
                        FlutterIcons.home_ant,
                        action: () {
                          //open wallet page
                          context.nextPage(WalletPage());
                        },
                      ).expand(flex: 2),

                      //topup button
                      CustomWalletButton(
                        "Top-Up".tr(),
                        FlutterIcons.plus_ant,
                        action: vm.showAmountEntry,
                      ).expand(flex: 2),

                      //user profile photo
                      CustomImage(
                        imageUrl: snapshot.data.photo,
                        width: 60,
                        height: 60,
                      )
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                          .py8()
                          .expand(flex: 2),
                      //tranfer button
                      Visibility(
                        visible: AppUISettings.allowWalletTransfer,
                        child: CustomWalletButton(
                          "SEND".tr(),
                          FlutterIcons.share_fea,
                          action: vm.showWalletTransferEntry,
                        ).expand(flex: 2),
                      ),

                      //RECEIVE button
                      Visibility(
                        visible: AppUISettings.allowWalletTransfer,
                        child: LoadingIndicator(
                          loading: vm.busy(vm.showMyWalletAddress),
                          child: CustomWalletButton(
                            "RECEIVE".tr(),
                            FlutterIcons.download_ant,
                            action: vm.showMyWalletAddress,
                          ).expand(flex: 2),
                        ),
                      ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                    alignment: MainAxisAlignment.center,
                  )
                      .px4()
                      .box
                      .clip(Clip.antiAlias)
                      .roundedLg
                      .color(AppColor.primaryColor)
                      .make(),
                ),
              ],
            )
                .p12()
                .box
                .rounded
                .outerShadowXl
                .color(context.backgroundColor)
                .make()
                .wFull(context);
          },
        );
      },
    );
  }
}
