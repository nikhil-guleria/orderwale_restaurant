class RazorPayResponse {
  int? code;
  String? message;
  RazorpayData? data;

  RazorPayResponse({this.code, this.message, this.data});

  RazorPayResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? RazorpayData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RazorpayData {
  int? amount;
  int? amountDue;
  int? amountPaid;
  int? attempts;
  int? createdAt;
  String? currency;
  String? entity;
  String? id;
  //List? notes;
  String? offerId;
  String? receipt;
  String? status;
  String? keyId;
  String? phone;

  RazorpayData(
      {this.amount,
        this.amountDue,
        this.amountPaid,
        this.attempts,
        this.createdAt,
        this.currency,
        this.entity,
        this.id,
        //this.notes,
        this.offerId,
        this.receipt,
        this.status,
        this.keyId,
        this.phone,
      });

  RazorpayData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    amountDue = json['amount_due'];
    amountPaid = json['amount_paid'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
    currency = json['currency'];
    entity = json['entity'];
    id = json['id'];
    /*if (json['notes'] != null) {
      notes = <Null>[];
      json['notes'].forEach((v) {
        notes!.add(Null.fromJson(v));
      });
    }*/
    offerId = json['offer_id'];
    receipt = json['receipt'];
    status = json['status'];
    keyId = json['key_id'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['amount_due'] = amountDue;
    data['amount_paid'] = amountPaid;
    data['attempts'] = attempts;
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['entity'] = entity;
    data['id'] = id;
   /* if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }*/
    data['offer_id'] = offerId;
    data['receipt'] = receipt;
    data['status'] = status;
    data['key_id'] = keyId;
    data['phone'] = phone;
    return data;
  }
}

