class RestaurantReviewsModel {
  List<Result>? result;

  RestaurantReviewsModel({this.result});

  RestaurantReviewsModel.fromJson(Map<String, dynamic> json) {
    json['result'] ??= <Result>[];
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? review;
  String? message;
  String? userName;
  String? city;
  String? userImage;
  String? date;

  Result(
      {this.review,
        this.message,
        this.userName,
        this.city,
        this.userImage,
        this.date});

  Result.fromJson(Map<String, dynamic> json) {
    review = json['review']??="";
    message = json['message'];
    userName = json['user_name'];
    city = json['city'];
    userImage = json['user_image'] ?? "";
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['review'] = this.review;
    data['message'] = this.message;
    data['user_name'] = this.userName;
    data['city'] = this.city;
    data['user_image'] = this.userImage;
    data['date'] = this.date;
    return data;
  }
}
