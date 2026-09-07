class ProfileModel {
  String? ownerId;
  String? name;
  String? email;
  String? profileImage;
  String? phone;
  String? totalOrders;
  String? todaysOrders;
  String? newOrders;
  String? totalEarnings;
  String? currentMonthEarnings;

  ProfileModel(
      {this.ownerId,
        this.name,
        this.email,
        this.profileImage,
        this.phone,
        this.totalOrders,
        this.todaysOrders,
        this.newOrders,
        this.totalEarnings,
        this.currentMonthEarnings});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    ownerId = json['owner_id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'] ?? "";
    phone = json['phone'];
    totalOrders = json['total_orders'];
    todaysOrders = json['todays_orders'];
    newOrders = json['new_orders'];
    totalEarnings = json['total_earnings'];
    currentMonthEarnings = json['current_month_earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_id'] = this.ownerId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['phone'] = this.phone;
    data['total_orders'] = this.totalOrders;
    data['todays_orders'] = this.todaysOrders;
    data['new_orders'] = this.newOrders;
    data['total_earnings'] = this.totalEarnings;
    data['current_month_earnings'] = this.currentMonthEarnings;
    return data;
  }
}
