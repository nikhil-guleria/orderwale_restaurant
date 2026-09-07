class CountriesModel {
  List<Result>? result;

  CountriesModel({this.result});

  CountriesModel.fromJson(Map<String, dynamic> json) {
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
  String? countryName;
  String? countryId;

  Result({this.countryName, this.countryId});

  Result.fromJson(Map<String, dynamic> json) {
    countryName = json['country_name'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_name'] = this.countryName;
    data['country_id'] = this.countryId;
    return data;
  }
}
