class StatesModel {
  List<Result>? result;

  StatesModel({this.result});

  StatesModel.fromJson(Map<String, dynamic> json) {
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
  String? stateName;
  String? stateId;

  Result({this.stateName, this.stateId});

  Result.fromJson(Map<String, dynamic> json) {
    stateName = json['state_name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_name'] = this.stateName;
    data['state_id'] = this.stateId;
    return data;
  }
}
