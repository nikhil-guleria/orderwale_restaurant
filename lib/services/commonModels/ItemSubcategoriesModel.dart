class ItemSubcategoriesModel {
  String? id;
  int? status;
  String? name;
  String? image;
  int? price;
  int? discount;
  int? discountType;
  int? type;
  String? description;

  ItemSubcategoriesModel(
      {this.id,
        this.status,
        this.name,
        this.image,
        this.price,
        this.discount,
        this.discountType,
        this.type,
        this.description});

  ItemSubcategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    discount = json['discount'];
    discountType = json['discount_type'];
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['type'] = type;
    data['description'] = description;
    return data;
  }
}