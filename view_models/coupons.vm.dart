import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/requests/coupon.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CouponViewModel extends MyBaseViewModel {
  //
  CouponRequest couponRequest = CouponRequest();
  List<Coupon> coupons = [];
  Coupon mainCoupon;

  //
  CouponViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    fetchCoupons();
  }

  //
  fetchCoupons() async {
    //
    setBusy(true);
    try {
      final mCoupons = await couponRequest.coupons();
      mainCoupon = mCoupons.first ?? null;
      coupons = mCoupons.sublist(1) ?? [];
      clearErrors();
    } catch (error) {
      setError(error);
      toastError("$error");
    }
    setBusy(false);
  }

  //
  copyCoupon(Coupon coupon) {
    Clipboard.setData(ClipboardData(text: coupon.code ?? ""));
    toastSuccessful("Coupon Code copied to clipboard".tr());
  }
}
