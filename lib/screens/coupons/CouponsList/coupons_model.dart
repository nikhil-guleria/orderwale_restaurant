class CouponsModel {
  List<CouponsListItem>? result = [];

  CouponsModel({this.result});

  CouponsModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CouponsListItem>[];
      json['result'].forEach((v) {
        result!.add( CouponsListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class CouponsListItem {
  int? id;
  String? couponCode;
  String? description;
  int? discountType;
  num? discount;
  String? startDate;
  String? endDate;
  int? time;
  String? restaurantId;
  String? image;
  String? thumbnailUrl;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? maxDiscount;
  String? minDiscount;
  bool? isApplied;
  String? restaurantName;

  CouponsListItem(
      {this.id,
        this.couponCode,
        this.description,
        this.discountType,
        this.discount,
        this.startDate,
        this.endDate,
        this.time,
        this.restaurantId,
        this.image,
        this.thumbnailUrl,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isApplied,
        this.maxDiscount,
        this.minDiscount,
        this.restaurantName,
      });

  CouponsListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponCode = json['coupon_code'];
    description = json['description'];
    discountType = json['discount_type'];
    discount = json['discount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    time = json['time'];
    restaurantId = json['restaurant_id'];
    image = json['image'] ?? "";
    thumbnailUrl = json['thumbnail_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isApplied = json['is_appied'];
    maxDiscount = json['max_discount'];
    minDiscount = json['min_discount'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['coupon_code'] = couponCode;
    data['description'] = description;
    data['discount_type'] = discountType;
    data['discount'] = discount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['time'] = time;
    data['restaurant_id'] = restaurantId;
    data['image'] = image;
    data['thumbnail_url'] = thumbnailUrl;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_appied'] = isApplied;
    data['max_discount'] = maxDiscount;
    data['min_discount'] = minDiscount;
    data['restaurant_name'] = restaurantName;
    return data;
  }
}
