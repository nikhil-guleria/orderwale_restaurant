class NotificationsModel {
  List<Result>? result;

  NotificationsModel({this.result});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add( Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? title;
  String? image;
  String? description;
  int? type;
  String? typeId;
  String? date;

  Result(
      {this.title,
        this.image,
        this.description,
        this.type,
        this.typeId,
        this.date});

  Result.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    description = json['description'];
    type = json['type'];
    typeId = json['type_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    data['date'] = this.date;
    return data;
  }
}
