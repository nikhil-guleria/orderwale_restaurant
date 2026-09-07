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