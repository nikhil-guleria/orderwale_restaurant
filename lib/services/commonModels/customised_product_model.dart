import 'package:food_merchant/screens/toppings/toppings_list/toppings_list_model.dart';

import 'customisation_list_model.dart';

class CustomisedProductModel {
  CustomisedProduct? result;

  CustomisedProductModel({this.result});

  CustomisedProductModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ?  CustomisedProduct.fromJson(json['result']) : null;
  }

}

class CustomisedProduct {
  List<CustomisedSubcategories>? subCategories = [];

  CustomisedProduct({this.subCategories});

  CustomisedProduct.fromJson(Map<String, dynamic> json) {
    if (json['subcategories'] != null) {
      subCategories = <CustomisedSubcategories>[];
      json['subcategories'].forEach((v) {
        subCategories!.add(CustomisedSubcategories.fromJson(v));
      });
    }
  }


}

class CustomisedCategories {
  String? categoryName;
  int? categoryId;
  List<CustomisedSubcategories>? subcategories = [];

  CustomisedCategories({this.categoryName, this.categoryId, this.subcategories});

  CustomisedCategories.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    if (json['subcategories'] != null) {
      subcategories = <CustomisedSubcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(CustomisedSubcategories.fromJson(v));
      });
    }
  }

}

class CustomisedSubcategories {
  int? id;
  String? title;
  int? restaurantId;
  int? categoryId;
  List<CustomisedItems>? items = [];

  CustomisedSubcategories(
      {this.id, this.title, this.restaurantId, this.categoryId, this.items});

  CustomisedSubcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    restaurantId = json['restaurant_id'];
    categoryId = json['category_id'];
    if (json['items'] != null) {
      items = <CustomisedItems>[];
      json['items'].forEach((v) {
        items!.add(CustomisedItems.fromJson(v));
      });
    }
  }
}

class CustomisedItems {
  String? id;
  int? status;
  String? categoryId;
  String? categoryName;
  String? customisationType;
  String? customisationTitle;
  String? name;
  String? image;
  num? price;
  num? discount;
  int? discountType;
  int? type;
  String? description;
  List<CustomisationItemModel>? customisations = [];
  List<Toppings>? toppings = [];

  CustomisedItems(
      {this.id,
        this.status,
        this.customisationType,
        this.customisationTitle,
        this.name,
        this.image,
        this.price,
        this.discount,
        this.discountType,
        this.type,
        this.description,
        this.customisations,
        this.toppings,
        this.categoryId,
        this.categoryName});

  CustomisedItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    status = json['status'];
    customisationType = json['customisation_type'] ?? "";
    customisationTitle = json['customisation_title'] ?? "";
    name = json['name'];
    image = json['image'] ?? '';
    price = json['price'] ?? 0;
    discount = json['discount'] ?? 0;
    discountType = json['discount_type'];
    type = json['type'];
    description = json['description'];
    if (json['customisations'] != null) {
      customisations = <CustomisationItemModel>[];
      json['customisations'].forEach((v) {
        customisations!.add(CustomisationItemModel.fromJson(v));
      });
    }
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(Toppings.fromJson(v));
      });
    }
  }

}






