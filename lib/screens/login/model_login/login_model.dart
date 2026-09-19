class LoginModel {
  int? id;
  String? name;
  String? email;
  String? profileImage;
  String? phone;
  String? address;
  String? pincode;

  LoginModel(
      {this.id,
        this.name,
        this.email,
        this.profileImage,
        this.phone,
        this.address,
        this.pincode});

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    phone = json['phone'];
    address = json['address'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profile_image'] = profileImage;
    data['phone'] = phone;
    data['address'] = address;
    data['pincode'] = pincode;
    return data;
  }
}



class RestaurantUserLoginModel {
  int? code;
  String? message;
  String? token;
  RestaurantUserLoginUser? user;

  RestaurantUserLoginModel({this.code, this.message, this.token, this.user});

  RestaurantUserLoginModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? RestaurantUserLoginUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}


class RestaurantUserLoginUser {
  String? name;
  String? role;
  String? deviceToken;
  int? restaurantId;
  String? restaurantName;
  String? restaurantLatitude;
  String? restaurantLongitude;
  int? ownerId;
  String? restaurantImage;
  String? restaurantThumbnail;
  String? restaurantPhone;

  RestaurantUserLoginUser(
      {this.name,
        this.role,
        this.deviceToken,
        this.restaurantId,
        this.restaurantName,
        this.restaurantLatitude,
        this.restaurantLongitude,
        this.ownerId,
        this.restaurantImage,
        this.restaurantThumbnail,
        this.restaurantPhone,
      });

  RestaurantUserLoginUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    deviceToken = json['device_token'];
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    restaurantLatitude = json['restaurant_latitude'];
    restaurantLongitude = json['restaurant_longitude'];
    ownerId = json['owner_id'];
    restaurantImage = json['restaurant_image'];
    restaurantThumbnail = json['restaurant_thumbnail'];
    restaurantPhone = json['restaurant_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['role'] = role;
    data['device_token'] = deviceToken;
    data['restaurant_id'] = restaurantId;
    data['restaurant_name'] = restaurantName;
    data['restaurant_latitude'] = restaurantLatitude;
    data['restaurant_longitude'] = restaurantLongitude;
    data['owner_id'] = ownerId;
    data['restaurant_image'] = restaurantImage;
    data['restaurant_thumbnail'] = restaurantThumbnail;
    data['restaurant_phone'] = restaurantPhone;
    return data;
  }
}