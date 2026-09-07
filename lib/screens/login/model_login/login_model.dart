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
