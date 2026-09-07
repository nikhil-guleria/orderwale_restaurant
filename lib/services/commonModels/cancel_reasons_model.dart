class CancelReasonsModel {
  int? code;
  String? message;
  List<CancelResult>? result;

  CancelReasonsModel({this.code, this.message, this.result});

  CancelReasonsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CancelResult>[];
      json['result'].forEach((v) {
        result!.add(CancelResult.fromJson(v));
      });
    }
  }

}

class CancelResult {
  int? id;
  int? reasonId;
  String? reasonTitle;
  int? status;
  String? createdAt;
  String? updatedAt;
  bool? selected;

  CancelResult(
      {this.id,
        this.reasonId,
        this.reasonTitle,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.selected});

  CancelResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reasonId = json['reason_id'];
    reasonTitle = json['reason_title'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    selected = false;
  }
}
