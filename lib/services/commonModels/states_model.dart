class StatesModel {
  List<StateData>? result;

  StatesModel({this.result});

  StatesModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <StateData>[];
      json['result'].forEach((v) {
        result!.add(StateData.fromJson(v));
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

class StateData {
  String? name;
  String? stateId;

  StateData({this.name, this.stateId});

  StateData.fromJson(Map<String, dynamic> json) {
    name = json['state_name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['state_name'] = name;
    data['state_id'] = stateId;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StateData &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              stateId == other.stateId;

  @override
  int get hashCode => name.hashCode ^ stateId.hashCode;
}