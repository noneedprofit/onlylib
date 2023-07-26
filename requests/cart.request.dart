import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/coupon.dart';
import 'package:fuodz/services/http.service.dart';

class CartRequest extends HttpService {
  //
  Future<Coupon> fetchCoupon(String code, {int vendorTypeId}) async {
    final apiResult = await get(
      "${Api.coupons}/$code",
      queryParameters: {
        "vendor_type_id": vendorTypeId,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Coupon.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message;
    }
  }
}
