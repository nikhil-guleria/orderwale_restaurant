class DashboardOrdersModel {
  int? code;
  String? message;
  DashboardOrdersResult? result;

  DashboardOrdersModel({this.code, this.message, this.result});

  DashboardOrdersModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
    json['result'] != null ? DashboardOrdersResult.fromJson(json['result']) : null;
  }
}

class DashboardOrdersResult {
  int? isAvailable;
  int? deliveryAvailability;
  List<DashboardOrdersData>? orders;

  DashboardOrdersResult({this.isAvailable, this.deliveryAvailability, this.orders});

  DashboardOrdersResult.fromJson(Map<String, dynamic> json) {
    isAvailable = json['is_available'];
    deliveryAvailability = json['delivery_availability'];
    if (json['orders'] != null) {
      orders = <DashboardOrdersData>[];
      json['orders'].forEach((v) {
        orders!.add(DashboardOrdersData.fromJson(v));
      });
    }
  }
}

class DashboardOrdersData {
  String? name;
  String? userName;
  String? userPhone;
  String? discountPrice;
  String? bannerImage;
  String? bannerThumbnail;
  String? address;
  String? orderId;
  String? orderStatus;
  String? deliveryType;
  String? totalPrice;
  String? walletPrice;
  String? paymentType;
  String? created;
  List<DashboardOrderItemDetails>? details;
  String? review;

  DashboardOrdersData(
      {this.name,
        this.userName,
        this.userPhone,
        this.discountPrice,
        this.bannerImage,
        this.bannerThumbnail,
        this.address,
        this.orderId,
        this.orderStatus,
        this.deliveryType,
        this.totalPrice,
        this.walletPrice,
        this.paymentType,
        this.created,
        this.details,
        this.review
      });

  DashboardOrdersData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    discountPrice = json['discount_price'];
    bannerImage = json['banner_image'];
    bannerThumbnail = json['banner_thumbnail'];
    address = json['address'];
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    deliveryType = json['delivery_type'];
    totalPrice = json['total_price'];
    walletPrice = json['wallet_price'];
    paymentType = json['payment_type'];
    created = json['created'];
    review = json['review'];
    if (json['details'] != null) {
      details = <DashboardOrderItemDetails>[];
      json['details'].forEach((v) {
        details!.add(DashboardOrderItemDetails.fromJson(v));
      });
    }
  }
}

class DashboardOrderItemDetails {
  String? customisationTitle;
  String? itemName;
  String? itemCount;
  String? type;
  String? price;
  String? itemImage;
  String? itemThumbnail;
  List<DashboardOrderToppings>? toppings;

  DashboardOrderItemDetails(
      {this.customisationTitle,
        this.itemName,
        this.itemCount,
        this.type,
        this.price,
        this.itemImage,
        this.itemThumbnail,
        this.toppings});

  DashboardOrderItemDetails.fromJson(Map<String, dynamic> json) {
    customisationTitle = json['customisation_title'];
    itemName = json['item_name'];
    itemCount = json['item_count'];
    type = json['type'];
    price = json['price'];
    itemImage = json['item_image'];
    itemThumbnail = json['item_thumbnail'];
    if (json['toppings'] != null) {
      toppings = <DashboardOrderToppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(DashboardOrderToppings.fromJson(v));
      });
    }
  }
}

class DashboardOrderToppings {
  int? id;
  int? restaurantId;
  String? title;
  String? type;
  num? price;
  String? createdAt;
  String? updatedAt;

  DashboardOrderToppings(
      {this.id,
        this.restaurantId,
        this.title,
        this.type,
        this.price,
        this.createdAt,
        this.updatedAt});

  DashboardOrderToppings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    title = json['title'];
    type = json['type'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
