class SubCategoryModel {
  List<SubCategoryResult>? result;

  SubCategoryModel({this.result});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <SubCategoryResult>[];
      json['result'].forEach((v) {
        result!.add( SubCategoryResult.fromJson(v));
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


class SubCategoryResult {
  int? categoryId;
  int? restaurantId;
  String? title;
  int? subcategoryId;

  SubCategoryResult({this.categoryId, this.restaurantId, this.title, this.subcategoryId});

  SubCategoryResult.fromJson(Map<String, dynamic> json) {
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
