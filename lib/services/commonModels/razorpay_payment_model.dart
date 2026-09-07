class RazorPayResponse {
  bool? status;
  String? message;
  RazorpayData? data;

  RazorPayResponse({this.status, this.message, this.data});

  RazorPayResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? RazorpayData.fromJson(json['data']) : null;
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
  List? notes;
  String? offerId;
  String? receipt;
  String? status;
  String? orderId;

  RazorpayData(
      {this.amount,
        this.amountDue,
        this.amountPaid,
        this.attempts,
        this.createdAt,
        this.currency,
        this.entity,
        this.id,
        this.notes,
        this.offerId,
        this.receipt,
        this.status,
        this.orderId});

  RazorpayData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    amountDue = json['amount_due'];
    amountPaid = json['amount_paid'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
    currency = json['currency'];
    entity = json['entity'];
    id = json['id'];
    notes = json['notes'];
    offerId = json['offer_id'];
    receipt = json['receipt'];
    status = json['status'];
    orderId = json['order_id'];
  }
}
