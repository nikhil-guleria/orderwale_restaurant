class RestaurantUserInfo {
  int? code;
  String? message;
  String? role;
  String? name;
  String? email;
  String? restaurantName;
  String? restaurantPhone;
  String? restaurantImage;
  String? restaurantThumbnail;

  RestaurantUserInfo(
      {this.code,
        this.message,
        this.role,
        this.name,
        this.email,
        this.restaurantName,
        this.restaurantPhone,
        this.restaurantImage,
        this.restaurantThumbnail});

  RestaurantUserInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    role = json['role'];
    name = json['name'];
    email = json['email'];
    restaurantName = json['restaurant_name'];
    restaurantPhone = json['restaurant_phone'];
    restaurantImage = json['restaurant_image'];
    restaurantThumbnail = json['restaurant_thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['role'] = role;
    data['name'] = name;
    data['email'] = email;
    data['restaurant_name'] = restaurantName;
    data['restaurant_phone'] = restaurantPhone;
    data['restaurant_image'] = restaurantImage;
    data['restaurant_thumbnail'] = restaurantThumbnail;
    return data;
  }
}
