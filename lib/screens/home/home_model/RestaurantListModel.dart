class RestaurantListModel {
  List<Result>? result;

  RestaurantListModel({this.result});

  RestaurantListModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? id;
  String? review;
  String? isAvailable;
  String? name;
  String? image;
  String? address;
  String? latitude;
  String? longitude;

  Result(
      {this.id,
        this.review,
        this.isAvailable,
        this.name,
        this.image,
        this.address,
        this.latitude,
        this.longitude});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'] ?? "0.0";
    isAvailable = json['is_available'];
    name = json['name'];
    image = json['image'] ?? "";
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review'] = this.review;
    data['is_available'] = this.isAvailable;
    data['name'] = this.name;
    data['image'] = this.image;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
