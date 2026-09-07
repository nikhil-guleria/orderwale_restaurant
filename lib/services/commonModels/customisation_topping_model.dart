class CustomisedToppingsModel {
  List<CustomisedToppings>? result;

  CustomisedToppingsModel({this.result});

  CustomisedToppingsModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CustomisedToppings>[];
      json['result'].forEach((v) {
        result!.add( CustomisedToppings.fromJson(v));
      });
    }
  }


}

class CustomisedToppings {
  int? id;
  int? restaurantId;
  String? title;
  String? type;
  int? price;
  String? createdAt;
  String? updatedAt;
  bool? selected;


  CustomisedToppings(
      {this.id,
        this.restaurantId,
        this.title,
        this.type,
        this.price,
        this.createdAt,
        this.updatedAt});

  CustomisedToppings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    title = json['title'];
    type = json['type'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    selected = false;
  }

}