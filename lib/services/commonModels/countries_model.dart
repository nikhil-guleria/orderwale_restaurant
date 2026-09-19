class CountriesModel {
  List<CountryData>? result;

  CountriesModel({this.result});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CountryData>[];
      json['result'].forEach((v) {
        result!.add(CountryData.fromJson(v));
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

class CountryData {
  String? name;
  String? countryId;

  CountryData({this.name, this.countryId});

  CountryData.fromJson(Map<String, dynamic> json) {
    name = json['country_name'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_name'] = name;
    data['country_id'] = countryId;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CountryData &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              countryId == other.countryId;

  @override
  int get hashCode => name.hashCode ^ countryId.hashCode;
}