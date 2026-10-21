class CustomisationModel {
  String? title;
  String? subTitle;

  CustomisationModel(
      { this.title, this.subTitle});
}

class CustomisationItemModel {
  String? title;
  String? price;
  String? id;
  String? itemId;
  String? type;
  CustomisationItemModel({this.title, this.price, this.id, this.itemId, this.type});

  CustomisationItemModel.fromJson(Map<String, dynamic> json) {
    id = (json['id'] ?? '').toString();
    itemId = (json['item_id'] ?? '').toString();
    title = json['title'].toString();
    type = json['type'].toString();
    price = (json['price'] ?? '').toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'id': id,
      'item_id':itemId,
      'type': type
    };
  }
}

void initialCustomisationList(List<CustomisationModel> list){
  list.add(CustomisationModel(title: "Portion", subTitle: "Half, Full"));
  list.add(CustomisationModel(title: "Weight", subTitle: "250g, ½ kg, 1 kg"));
  list.add(CustomisationModel(title: "Size", subTitle: "Small, Medium, Large"));
  list.add(CustomisationModel(title: "Pieces", subTitle: "4 Pieces, 6 Pieces, 8 Pieces, 12 Pieces"));

}

void portionCustomisationList(List<CustomisationItemModel> list){
  list.add(CustomisationItemModel(title: "Half", price: "", id: "",itemId: "",type: "Portion"));
  list.add(CustomisationItemModel(title: "Full", price: "", id: "",itemId: "",type: "Portion"));
}

void weightCustomisationList(List<CustomisationItemModel> list){
  list.add(CustomisationItemModel(title: "250 g", price: "", id: "",itemId: "",type: "Weight"));
  list.add(CustomisationItemModel(title: "½ kg", price: "", id: "",itemId: "",type: "Weight"));
  list.add(CustomisationItemModel(title: "1 kg", price: "", id: "",itemId: "",type: "Weight"));
}

void sizeCustomisationList(List<CustomisationItemModel> list){
  list.add(CustomisationItemModel(title: "Small", price: "", id: "",itemId: "",type: "Size"));
  list.add(CustomisationItemModel(title: "Medium", price: "", id: "",itemId: "",type: "Size"));
  list.add(CustomisationItemModel(title: "Large", price: "", id: "",itemId: "",type: "Size"));
}

void piecesCustomisationList(List<CustomisationItemModel> list){
  list.add(CustomisationItemModel(title: "4 Pieces", price: "", id: "",itemId: "",type: "Pieces"));
  list.add(CustomisationItemModel(title: "6 Pieces", price: "", id: "",itemId: "",type: "Pieces"));
  list.add(CustomisationItemModel(title: "8 Pieces", price: "", id: "",itemId: "",type: "Pieces"));
  list.add(CustomisationItemModel(title: "12 Pieces", price: "", id: "",itemId: "",type: "Pieces"));
}


