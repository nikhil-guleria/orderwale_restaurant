class CashFreeResponse {
  int? code;
  String? message;
  CashFreeData? data;

  CashFreeResponse({this.code, this.message, this.data});

  CashFreeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? CashFreeData.fromJson(json['data']) : null;
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

class CashFreeData {
  //Null? cartDetails;
  String? cfOrderId;
  String? createdAt;
  CustomerDetails? customerDetails;
  String? entity;
  num? orderAmount;
  String? orderCurrency;
  String? orderExpiryTime;
  String? orderId;
  OrderMeta? orderMeta;
  String? orderNote;
  //List<Null>? orderSplits;
  String? orderStatus;
  //Null? orderTags;
  String? paymentSessionId;
  Products? products;
  //Null? terminalData;



  CashFreeData(
      {//this.cartDetails,
        this.cfOrderId,
        this.createdAt,
        this.customerDetails,
        this.entity,
        this.orderAmount,
        this.orderCurrency,
        this.orderExpiryTime,
        this.orderId,
        this.orderMeta,
        this.orderNote,
        //this.orderSplits,
        this.orderStatus,
        //this.orderTags,
        this.paymentSessionId,
        this.products,
        //this.terminalData
      });

  CashFreeData.fromJson(Map<String, dynamic> json) {
    //cartDetails = json['cart_details'];
    cfOrderId = json['cf_order_id'];
    createdAt = json['created_at'];
    customerDetails = json['customer_details'] != null
        ? CustomerDetails.fromJson(json['customer_details'])
        : null;
    entity = json['entity'];
    orderAmount = json['order_amount'];
    orderCurrency = json['order_currency'];
    orderExpiryTime = json['order_expiry_time'];
    orderId = json['order_id'];
    orderMeta = json['order_meta'] != null
        ? OrderMeta.fromJson(json['order_meta'])
        : null;
    orderNote = json['order_note'];
    /*if (json['order_splits'] != null) {
      orderSplits = <Null>[];
      json['order_splits'].forEach((v) {
        orderSplits!.add(new Null.fromJson(v));
      });
    }*/
    orderStatus = json['order_status'];
    //orderTags = json['order_tags'];
    paymentSessionId = json['payment_session_id'];
    products = json['products'] != null
        ? Products.fromJson(json['products'])
        : null;
    //terminalData = json['terminal_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['cart_details'] = this.cartDetails;
    data['cf_order_id'] = cfOrderId;
    data['created_at'] = createdAt;
    if (customerDetails != null) {
      data['customer_details'] = customerDetails!.toJson();
    }
    data['entity'] = entity;
    data['order_amount'] = orderAmount;
    data['order_currency'] = orderCurrency;
    data['order_expiry_time'] = orderExpiryTime;
    data['order_id'] = orderId;
    if (orderMeta != null) {
      data['order_meta'] = orderMeta!.toJson();
    }
    data['order_note'] = orderNote;
    /*if (this.orderSplits != null) {
      data['order_splits'] = this.orderSplits!.map((v) => v.toJson()).toList();
    }*/
    data['order_status'] = orderStatus;
    //data['order_tags'] = orderTags;
    data['payment_session_id'] = paymentSessionId;
    if (products != null) {
      data['products'] = products!.toJson();
    }
    //data['terminal_data'] = terminalData;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['customer_email'] = customerEmail;
    data['customer_phone'] = customerPhone;
    data['customer_uid'] = customerUid;
    return data;
  }
}

class OrderMeta {
  String? notifyUrl;
  String? paymentMethods;
  String? paymentMethodsFilters;
  String? returnUrl;

  OrderMeta(
      {this.notifyUrl,
        this.paymentMethods,
        this.paymentMethodsFilters,
        this.returnUrl});

  OrderMeta.fromJson(Map<String, dynamic> json) {
    notifyUrl = json['notify_url'];
    paymentMethods = json['payment_methods'];
    paymentMethodsFilters = json['payment_methods_filters'];
    returnUrl = json['return_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notify_url'] = notifyUrl;
    data['payment_methods'] = paymentMethods;
    data['payment_methods_filters'] = paymentMethodsFilters;
    data['return_url'] = returnUrl;
    return data;
  }
}

class Products {
  OneClickCheckout? oneClickCheckout;
  OneClickCheckout? verifyPay;

  Products({this.oneClickCheckout, this.verifyPay});

  Products.fromJson(Map<String, dynamic> json) {
    oneClickCheckout = json['one_click_checkout'] != null
        ? OneClickCheckout.fromJson(json['one_click_checkout'])
        : null;
    verifyPay = json['verify_pay'] != null
        ? OneClickCheckout.fromJson(json['verify_pay'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (oneClickCheckout != null) {
      data['one_click_checkout'] = oneClickCheckout!.toJson();
    }
    if (verifyPay != null) {
      data['verify_pay'] = verifyPay!.toJson();
    }
    return data;
  }
}

class OneClickCheckout {
  bool? enabled;
  //List<Null>? conditions;

  OneClickCheckout({this.enabled, //this.conditions
  });

  OneClickCheckout.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    /*if (json['conditions'] != null) {
      conditions = <Null>[];
      json['conditions'].forEach((v) {
        conditions!.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enabled'] = enabled;
    /*if (this.conditions != null) {
      data['conditions'] = this.conditions!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

