class CitiesModel {
  List<Result>? result;

  CitiesModel({this.result});

  CitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? cityName;
  String? cityId;

  Result({this.cityName, this.cityId});

  Result.fromJson(Map<String, dynamic> json) {
    cityName = json['city_name'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_name'] = this.cityName;
    data['city_id'] = this.cityId;
    return data;
  }
}
