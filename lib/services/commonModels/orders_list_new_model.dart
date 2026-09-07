class OrdersModelNew {
  OrdersResultNew? result;

  OrdersModelNew({this.result});

  OrdersModelNew.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ?  OrdersResultNew.fromJson(json['result']) : null;
  }
}

class OrdersResultNew {
  int? isAvailable;
  List<OrdersNew>? orders = [];

  OrdersResultNew({this.isAvailable, this.orders});

  OrdersResultNew.fromJson(Map<String, dynamic> json) {
    isAvailable = json['is_available'];
    if (json['orders'] != null) {
      orders = <OrdersNew>[];
      json['orders'].forEach((v) {
        orders!.add(OrdersNew.fromJson(v));
      });
    }
  }
}

class OrdersNew {
  String? name;
  String? discountPrice;
  String? bannerImage;
  String? address;
  String? orderId;
  String? orderStatus;
  String? deliveryType;
  String? totalPrice;
  String? walletPrice;
  String? created;
  String? paymentType;
  List<ItemDetailsNew>? details = [];
  String? review;

  OrdersNew(
      {this.name,
        this.discountPrice,
        this.bannerImage,
        this.address,
        this.orderId,
        this.orderStatus,
        this.deliveryType,
        this.totalPrice,
        this.walletPrice,
        this.created,
        this.paymentType,
        this.details,
        this.review});

  OrdersNew.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    discountPrice = json['discount_price'];
    bannerImage = json['banner_image'];
    address = json['address'];
    orderId = json['order_id'];
    orderStatus = json['order_status'] ?? "";
    deliveryType = json['delivery_type'];
    totalPrice = json['total_price'];
    walletPrice = json['wallet_price'];
    created = json['created'];
    paymentType = json['payment_type'];
    if (json['details'] != null) {
      details = <ItemDetailsNew>[];
      json['details'].forEach((v) {
        details!.add(ItemDetailsNew.fromJson(v));
      });
    }
    review = json['review'];
  }
}

class ItemDetailsNew {
  String? itemName;
  String? itemCount;
  String? type;
  String? price;
  String? itemImage;
  String? customisationTitle = "";
  List<Toppings>? toppings = [];

  ItemDetailsNew(
      {this.itemName, this.itemCount, this.type, this.price, this.itemImage,
        this.customisationTitle, this.toppings});

  ItemDetailsNew.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemCount = json['item_count'];
    type = json['type'];
    price = json['price'];
    itemImage = json['item_image'] ?? "";
    customisationTitle = json['customisation_title'] ?? "";
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(Toppings.fromJson(v));
      });
    }
  }
}

class Toppings {
  int? id;
  int? restaurantId;
  String? title;
  String? type;
  int? price;
  String? createdAt;
  String? updatedAt;

  Toppings(
      {this.id,
        this.restaurantId,
        this.title,
        this.type,
        this.price,
        this.createdAt,
        this.updatedAt});

  Toppings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    title = json['title'];
    type = json['type'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
