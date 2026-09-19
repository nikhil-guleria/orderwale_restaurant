class CitiesModel {
  List<CityData>? result;

  CitiesModel({this.result});

  CitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CityData>[];
      json['result'].forEach((v) {
        result!.add(CityData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityData {
  String? name;
  String? cityId;

  CityData({this.name, this.cityId});

  CityData.fromJson(Map<String, dynamic> json) {
    name = json['city_name'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['city_name'] = name;
    data['city_id'] = cityId;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CityData &&
              runtimeType == other.runtimeType &&
              cityId == other.cityId;

  @override
  int get hashCode => cityId.hashCode;
}