class OrdersPageModel {
  int? code;
  String? message;
  List<OrdersPageData>? result;
  int? currentPage;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  OrdersPageModel(
      {this.code,
        this.message,
        this.result,
        this.currentPage,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  OrdersPageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <OrdersPageData>[];
      json['result'].forEach((v) {
        result!.add(OrdersPageData.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = currentPage;
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class OrdersPageData {
  String? orderId;
  String? created;
  String? deliveryType;
  String? totalPrice;
  String? walletPrice;
  String? paymentType;
  String? orderStatus;
  String? deliveryAddress;

  OrdersPageData(
      {this.orderId,
        this.created,
        this.deliveryType,
        this.totalPrice,
        this.walletPrice,
        this.paymentType,
        this.orderStatus,
        this.deliveryAddress});

  OrdersPageData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    created = json['created'];
    deliveryType = json['delivery_type'];
    totalPrice = json['total_price'];
    walletPrice = json['wallet_price'];
    paymentType = json['payment_type'];
    orderStatus = json['order_status'];
    deliveryAddress = json['delivery_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['created'] = created;
    data['delivery_type'] = deliveryType;
    data['total_price'] = totalPrice;
    data['wallet_price'] = walletPrice;
    data['payment_type'] = paymentType;
    data['order_status'] = orderStatus;
    data['delivery_address'] = deliveryAddress;
    return data;
  }
}
