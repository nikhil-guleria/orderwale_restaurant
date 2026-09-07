class CashFreeResponse {
  bool? status;
  String? message;
  CashFreeData? data;

  CashFreeResponse({this.status, this.message, this.data});

  CashFreeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CashFreeData.fromJson(json['data']) : null;
  }

}

class CashFreeData {
  int? cfOrderId;
  String? createdAt;
  CustomerDetails? customerDetails;
  String? entity;
  int? orderAmount;
  String? orderCurrency;
  String? orderExpiryTime;
  String? orderId;
  OrderMeta? orderMeta;
  String? orderNote;
  List? orderSplits;
  String? orderStatus;
  //Null? orderTags;
  String? paymentSessionId;
  Payments? payments;
  Payments? refunds;
  Payments? settlements;
  //Null? terminalData;

  CashFreeData(
      {this.cfOrderId,
        this.createdAt,
        this.customerDetails,
        this.entity,
        this.orderAmount,
        this.orderCurrency,
        this.orderExpiryTime,
        this.orderId,
        this.orderMeta,
        this.orderNote,
        this.orderSplits,
        this.orderStatus,
        this.paymentSessionId,
        this.payments,
        this.refunds,
        this.settlements});

  CashFreeData.fromJson(Map<String, dynamic> json) {
    cfOrderId = json['cf_order_id'];
    createdAt = json['created_at'];
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    entity = json['entity'];
    orderAmount = json['order_amount'];
    orderCurrency = json['order_currency'];
    orderExpiryTime = json['order_expiry_time'];
    orderId = json['order_id'];
    orderMeta = json['order_meta'] != null
        ? new OrderMeta.fromJson(json['order_meta'])
        : null;
    orderNote = json['order_note'];
    orderSplits = json['order_splits'];
    orderStatus = json['order_status'];
    paymentSessionId = json['payment_session_id'];
    payments = json['payments'] != null
        ? new Payments.fromJson(json['payments'])
        : null;
    refunds =
    json['refunds'] != null ? new Payments.fromJson(json['refunds']) : null;
    settlements = json['settlements'] != null
        ? new Payments.fromJson(json['settlements'])
        : null;
  }
}

class CustomerDetails {
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? customerUid;

  CustomerDetails(
      {this.customerId,
        this.customerName,
        this.customerEmail,
        this.customerPhone,
        this.customerUid});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
    customerUid = json['customer_uid'];
  }

}

class OrderMeta {
  String? returnUrl;
  String? notifyUrl;
  String? paymentMethods;

  OrderMeta({this.returnUrl, this.notifyUrl, this.paymentMethods});

  OrderMeta.fromJson(Map<String, dynamic> json) {
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    paymentMethods = json['payment_methods'];
  }
}

class Payments {
  String? url;

  Payments({this.url});

  Payments.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

}
