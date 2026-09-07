class ItemSubCategoryModel {
  List<ItemSubCategory>? result;

  ItemSubCategoryModel({this.result});

  ItemSubCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <ItemSubCategory>[];
      json['result'].forEach((v) {
        result!.add( ItemSubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ItemSubCategory {
  int? categoryId;
  int? restaurantId;
  String? title;
  int? subcategoryId;

  ItemSubCategory({this.categoryId, this.restaurantId, this.title, this.subcategoryId});

  ItemSubCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    restaurantId = json['restaurant_id'];
    title = json['title'];
    subcategoryId = json['subcategory_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['category_id'] = categoryId;
    data['restaurant_id'] = restaurantId;
    data['title'] = title;
    data['subcategory_id'] = subcategoryId;
    return data;
  }
}