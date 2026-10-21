import 'package:food_merchant/screens/toppings/toppings_list/toppings_list_model.dart';
import 'package:food_merchant/services/commonModels/customisation_list_model.dart';

class RestaurantMenuModel {
  RestaurantMenuResult? result;

  RestaurantMenuModel({this.result});

  RestaurantMenuModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ?  RestaurantMenuResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class RestaurantMenuResult {
  List<RestaurantMenuSubcategories>? subcategories;

  RestaurantMenuResult({this.subcategories});

  RestaurantMenuResult.fromJson(Map<String, dynamic> json) {
    if (json['subcategories'] != null) {
      subcategories = <RestaurantMenuSubcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(RestaurantMenuSubcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (subcategories != null) {
      data['subcategories'] =
          subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantMenuSubcategories {
  int? id;
  String? title;
  int? restaurantId;
  int? categoryId;
  List<RestaurantMenuItem>? items;

  RestaurantMenuSubcategories(
      {this.id, this.title, this.restaurantId, this.categoryId, this.items});

  RestaurantMenuSubcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    restaurantId = json['restaurant_id'];
    categoryId = json['category_id'];
    if (json['items'] != null) {
      items = <RestaurantMenuItem>[];
      json['items'].forEach((v) {
        items!.add(RestaurantMenuItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['restaurant_id'] = restaurantId;
    data['category_id'] = categoryId;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantMenuItem {
  String? id;
  String? categoryId;
  String? categoryName;
  int? status;
  String? customisationType;
  String? customisationTitle;
  String? name;
  String? image;
  String? thumbnail;
  num? price;
  num? discount;
  int? discountType;
  int? type;
  String? description;
  List<CustomisationItemModel>? customisations;
  List<Toppings>? toppings;

  RestaurantMenuItem(
      {this.id,
        this.categoryId,
        this.categoryName,
        this.status,
        this.customisationType,
        this.customisationTitle,
        this.name,
        this.image,
        this.thumbnail,
        this.price,
        this.discount,
        this.discountType,
        this.type,
        this.description,
        this.customisations,
        this.toppings,
      });

  RestaurantMenuItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    status = json['status'];
    customisationType = json['customisation_type'];
    customisationTitle = json['customisation_title'];
    name = json['name'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    price = json['price'];
    discount = json['discount'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['status'] = status;
    data['customisation_type'] = customisationType;
    data['customisation_title'] = customisationTitle;
    data['name'] = name;
    data['image'] = image;
    data['thumbnail'] = thumbnail;
    data['price'] = price;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['type'] = type;
    data['description'] = description;
    if (customisations != null) {
      data['customisations'] =
          customisations!.map((v) => v.toMap()).toList();
    }
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}