
class ProductItemModel {
  ProductList? result;

  ProductItemModel({this.result});

  ProductItemModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ?  ProductList.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class ProductList {
  List<Categories>? categories;

  ProductList({this.categories});

  ProductList.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add( Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? categoryName;
  int? categoryId;
  List<Subcategories>? subcategories;

  Categories({this.categoryName, this.categoryId, this.subcategories});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    if (subcategories != null) {
      data['subcategories'] =
          subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategories {
  int? id;
  String? title;
  int? restaurantId;
  int? categoryId;
  List<Items>? items;

  Subcategories(
      {this.id, this.title, this.restaurantId, this.categoryId, this.items});

  Subcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    restaurantId = json['restaurant_id'];
    categoryId = json['category_id'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
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

class Items {
  String? id;
  int? status;
  String? name;
  String? image;
  num? price;
  num? discount;
  int? discountType;
  int? type;
  String? description;

  Items(
      {this.id,
        this.status,
        this.name,
        this.image,
        this.price,
        this.discount,
        this.discountType,
        this.type,
        this.description});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    name = json['name'];
    image = json['image'] ?? "";
    price = json['price'];
    discount = json['discount'] ?? 0;
    discountType = json['discount_type'];
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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





