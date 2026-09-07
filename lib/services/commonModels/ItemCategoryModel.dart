import 'ItemSubcategoriesModel.dart';

class ItemCategoryModel {
  String? categoryName;
  int? categoryId;
  List<ItemSubcategoriesModel>? subcategories;

  ItemCategoryModel({this.categoryName, this.categoryId, this.subcategories});

  ItemCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    if (json['subcategories'] != null) {
      subcategories = <ItemSubcategoriesModel>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(ItemSubcategoriesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['category_id'] = this.categoryId;
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}