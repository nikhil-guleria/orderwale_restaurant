class RestaurantDetailsModel {
  String? restaurantId;
  String? avgReview;
  String? name;
  String? deliveryAvailability;
  String? country;
  String? countryId;
  String? stateId;
  String? cityId;
  String? state;
  String? city;
  String? pinCode;
  String? email;
  String? fssaiNo;
  String? bannerImage;
  String? bannerThumbnail;
  String? phone;
  String? address;
  String? openingTime;
  String? closingTime;
  String? latitude;
  String? longitude;
  String? minDeliveryCharges;
  String? chargesPerKm;
  String? minOrderPrice;
  String? minDeliveryDistance;
  num? averagePrice;
  num? discount;
  int? discountType;
  num? freeDeliveryAmount;
  int? isAvailable;
  List<CustomerReviewModel>? reviews = [];

  RestaurantDetailsModel(
      {this.restaurantId,
        this.avgReview,
        this.name,
        this.deliveryAvailability,
        this.country,
        this.countryId,
        this.stateId,
        this.cityId,
        this.state,
        this.city,
        this.pinCode,
        this.email,
        this.fssaiNo,
        this.bannerImage,
        this.bannerThumbnail,
        this.phone,
        this.address,
        this.openingTime,
        this.closingTime,
        this.latitude,
        this.longitude,
        this.averagePrice,
        this.discount,
        this.discountType,
        this.freeDeliveryAmount,
        this.isAvailable,
        this.reviews,
        this.minDeliveryCharges,
        this.chargesPerKm,
        this.minDeliveryDistance,
        this.minOrderPrice});

  RestaurantDetailsModel.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    avgReview = json['avg_review'] ?? "0.0";
    name = json['name'];
    deliveryAvailability = json['delivery_availability'];
    country = json['country'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    state = json['state'];
    city = json['city'];
    pinCode = json['pincode'];
    email = json['email'];
    fssaiNo = json['fssai_no'];
    bannerImage = json['banner_image'] ?? "";
    bannerThumbnail = json['banner_thumbnail'];
    phone = json['phone'];
    address = json['address'];
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
    latitude = json['latitude'] ?? "0.0";
    longitude = json['longitude'] ?? "0.0";
    averagePrice = json['average_price'];
    discount = json['discount'];
    discountType = json['discount_type'];
    freeDeliveryAmount = json['free_delivery_amount'];
    isAvailable = json['is_available'];
    minDeliveryCharges = json["min_delivery_charges"];
    chargesPerKm = json["charges_per_km"];
    minOrderPrice = json["minimum_order_price"];
    minDeliveryDistance = json["minimum_delivery_distance"];
    if (json['reviews'] != null) {
      reviews = <CustomerReviewModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(CustomerReviewModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant_id'] = restaurantId;
    data['avg_review'] = avgReview;
    data['name'] = name;
    data['delivery_availability'] = deliveryAvailability;
    data['country'] = country;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['state'] = state;
    data['city'] = city;
    data['pincode'] = pinCode;
    data['email'] = email;
    data['fssai_no'] = fssaiNo;
    data['banner_image'] = bannerImage;
    data['banner_thumbnail'] = bannerThumbnail;
    data['phone'] = phone;
    data['address'] = address;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['average_price'] = averagePrice;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['free_delivery_amount'] = freeDeliveryAmount;
    data['is_available'] = isAvailable;
    data["charges_per_km"] = chargesPerKm;
    data["min_delivery_charges"] = minDeliveryCharges;
    data["minimum_order_price"] = minOrderPrice;
    data["minimum_delivery_distance"] = minDeliveryDistance;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerReviewModel {
  String? review;
  String? message;
  String? userName;
  String? city;
  String? userImage;
  String? date;

  CustomerReviewModel(
      {this.review,
        this.message,
        this.userName,
        this.city,
        this.userImage,
        this.date});

  CustomerReviewModel.fromJson(Map<String, dynamic> json) {
    review = json['review'];
    message = json['message'];
    userName = json['user_name'];
    city = json['city'];
    userImage = json['user_image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review'] = review;
    data['message'] = message;
    data['user_name'] = userName;
    data['city'] = city;
    data['user_image'] = userImage;
    data['date'] = date;
    return data;
  }
}




