import 'package:fuodz/constants/custom_api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/services/http.service.dart';

class CouponRequest extends HttpService {
  //
  Future<List<Coupon>> coupons() async {
    final apiResult = await get(CustomApi.coupons);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map((jsonObject) => Coupon.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message;
  }
}
