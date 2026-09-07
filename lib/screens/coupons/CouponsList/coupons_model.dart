class CouponsModel {
  int? code;
  String? message;
  List<CouponsData>? result;

  CouponsModel({this.code, this.message, this.result});

  CouponsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CouponsData>[];
      json['result'].forEach((v) {
        result!.add(CouponsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponsData {
  bool? isApplied;
  String? couponCode;
  String? image;
  int? id;
  String? description;
  String? startDate;
  String? endDate;
  int? discount;
  int? discountType;
  String? maxDiscount;
  String? minDiscount;
  int? time;

  CouponsData(
      { this.isApplied,
        this.couponCode,
        this.image,
        this.id,
        this.description,
        this.startDate,
        this.endDate,
        this.discount,
        this.discountType,
        this.maxDiscount,
        this.minDiscount,
        this.time,
      });

  CouponsData.fromJson(Map<String, dynamic> json) {
    isApplied = json['is_appied'];
    couponCode = json['coupon_code'];
    image = json['image'] ?? '';
    id = json['id'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    discount = json['discount'];
    discountType = json['discount_type'];
    maxDiscount = json['max_discount'];
    minDiscount = json['min_discount'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['is_appied'] = isApplied;
    data['coupon_code'] = couponCode;
    data['image'] = image;
    data['id'] = id;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['max_discount'] = maxDiscount;
    data['min_discount'] = minDiscount;
    data['time'] = time;
    return data;
  }
}
