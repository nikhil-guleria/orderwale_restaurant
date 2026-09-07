class ItemCategoriesModel {
  List<ItemCategory>? result;

  ItemCategoriesModel({this.result});

  ItemCategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <ItemCategory>[];
      json['result'].forEach((v) {
        result!.add( ItemCategory.fromJson(v));
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

class ItemCategory {
  String? categoryName;
  String? image;
  String? categoryId;
  String? totalCount;

  ItemCategory({this.categoryName, this.image, this.categoryId, this.totalCount});

  ItemCategory.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    image = json['image'];
    categoryId = json['category_id'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['category_name'] = categoryName;
    data['image'] = image;
    data['category_id'] = categoryId;
    data['total_count'] = totalCount;
    return data;
  }
}