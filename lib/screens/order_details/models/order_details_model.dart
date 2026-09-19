//----------------------------------------------------------------------
//------------------------> order details <-----------------------------
//----------------------------------------------------------------------
class RestaurantOrderDetailsModel {
  int? code;
  String? message;
  RestaurantOrderData? result;

  RestaurantOrderDetailsModel({this.code, this.message, this.result});

  RestaurantOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
    json['result'] != null ? RestaurantOrderData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class RestaurantOrderData {
  String? name;
  String? userName;
  String? phone;
  String? deliveryAddress;
  String? discountPrice;
  String? bannerImage;
  String? bannerThumbnail;
  String? address;
  String? latitude;
  String? longitude;
  String? restaurantAddress;
  String? restaurantPhone;
  String? fssaiNo;
  String? orderId;
  String? orderStatus;
  String? deliveryType;
  String? totalPrice;
  String? roundOff;
  String? walletPrice;
  String? paymentType;
  int? floorId;
  String? floorName;
  int? tableNo;
  String? created;
  List<KotOrdersData>? kots;
  String? gst;
  String? appliedTaxes;
  String? packagingCharges;
  String? platformFee;
  String? tipPrice;
  String? adminCharge;
  String? deliveryCharge;
  String? itemsTotal;
  int? userType;
  String? deliveryDateTime;
  String? restaurantLatitude;
  String? restaurantLongitude;


  RestaurantOrderData(
      {this.name,
        this.userName,
        this.phone,
        this.deliveryAddress,
        this.discountPrice,
        this.bannerImage,
        this.bannerThumbnail,
        this.address,
        this.latitude,
        this.longitude,
        this.restaurantAddress,
        this.restaurantPhone,
        this.fssaiNo,
        this.orderId,
        this.orderStatus,
        this.deliveryType,
        this.totalPrice,
        this.roundOff,
        this.walletPrice,
        this.paymentType,
        this.floorId,
        this.floorName,
        this.tableNo,
        this.created,
        this.kots,
        this.gst,
        this.appliedTaxes,
        this.packagingCharges,
        this.platformFee,
        this.tipPrice,
        this.adminCharge,
        this.deliveryCharge,
        this.itemsTotal,
        this.userType,
        this.deliveryDateTime,
        this.restaurantLatitude,
        this.restaurantLongitude,
      });

  RestaurantOrderData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userName = json['user_name'];
    phone = json['phone'];
    deliveryAddress = json['delivery_address'];
    discountPrice = json['discount_price'];
    bannerImage = json['banner_image'];
    bannerThumbnail = json['banner_thumbnail'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    restaurantAddress = json['restaurant_address'];
    restaurantPhone = json['restaurant_phone'];
    fssaiNo = json['fssai_no'];
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    deliveryType = json['delivery_type'];
    totalPrice = json['total_price'];
    roundOff  = json['round_off'];
    walletPrice = json['wallet_price'];
    paymentType = json['payment_type'];
    floorId = json['floor_id'];
    floorName = json['floor_name'];
    tableNo = json['table_no'];
    created = json['created'];
    if (json['kots'] != null) {
      kots = <KotOrdersData>[];
      json['kots'].forEach((v) {
        kots!.add(KotOrdersData.fromJson(v));
      });
    }
    gst = json['gst'];
    appliedTaxes = json['applied_taxes'];
    packagingCharges = json['packaging_charges'];
    platformFee = json['platform_fee'];
    tipPrice = json['tip_price'];
    adminCharge = json['admin_charge'];
    deliveryCharge = json['delivery_charge'];
    itemsTotal = json['items_total'];
    userType = json['user_type'];
    deliveryDateTime = json['delivery_date_time'];
    restaurantLatitude = json['restaurant_latitude'];
    restaurantLongitude = json['restaurant_longitude'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['user_name'] = userName;
    data['phone'] = phone;
    data['delivery_address'] = deliveryAddress;
    data['discount_price'] = discountPrice;
    data['banner_image'] = bannerImage;
    data['banner_thumbnail'] = bannerThumbnail;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['restaurant_address'] = restaurantAddress;
    data['restaurant_phone'] = restaurantPhone;
    data['fssai_no'] = fssaiNo;
    data['order_id'] = orderId;
    data['order_status'] = orderStatus;
    data['delivery_type'] = deliveryType;
    data['total_price'] = totalPrice;
    data['round_off']  = roundOff;
    data['wallet_price'] = walletPrice;
    data['payment_type'] = paymentType;
    data['floor_id'] = floorId;
    data['floor_name'] = floorName;
    data['table_no'] = tableNo;
    data['created'] = created;
    if (kots != null) {
      data['kots'] = kots!.map((v) => v.toJson()).toList();
    }
    data['gst'] = gst;
    data['applied_taxes'] = appliedTaxes;
    data['packaging_charges'] = packagingCharges;
    data['platform_fee'] = platformFee;
    data['tip_price'] = tipPrice;
    data['admin_charge'] = adminCharge;
    data['delivery_charge'] = deliveryCharge;
    data['items_total'] = itemsTotal;
    data['user_type'] = userType;
    data['delivery_date_time'] = deliveryDateTime;
    data['restaurant_latitude'] = restaurantLatitude;
    data['restaurant_longitude'] = restaurantLongitude;
    return data;
  }
}

class KotOrdersData {
  int? kotNo;
  int? itemCount;
  List<RestaurantOrderItemsData>? items;

  KotOrdersData({this.kotNo, this.itemCount, this.items});

  KotOrdersData.fromJson(Map<String, dynamic> json) {
    kotNo = json['kot_no'];
    itemCount = json['item_count'];
    if (json['items'] != null) {
      items = <RestaurantOrderItemsData>[];
      json['items'].forEach((v) {
        items!.add(RestaurantOrderItemsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['kot_no'] = kotNo;
    data['item_count'] = itemCount;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class RestaurantOrderItemsData {
  int? id;
  int? status;
  int? customisationId;
  String? customisationTitle;
  String? itemName;
  int? itemCount;
  String? type;
  num? price;
  String? itemImage;
  String? itemThumbnail;
  List<RestaurantToppingsData>? toppings;
  int? kotNo;

  RestaurantOrderItemsData(
      { this.id,
        this.status,
        this.customisationId,
        this.customisationTitle,
        this.itemName,
        this.itemCount,
        this.type,
        this.price,
        this.itemImage,
        this.itemThumbnail,
        this.toppings,
        this.kotNo,
      });

  RestaurantOrderItemsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    customisationId = json['customisation_id'];
    customisationTitle = json['customisation_title'];
    itemName = json['item_name'];
    itemCount = json['item_count'];
    type = json['type'];
    price = json['price'];
    itemImage = json['item_image'];
    itemThumbnail = json['item_thumbnail'];
    kotNo = json['kot_no'];
    if (json['toppings'] != null) {
      toppings = <RestaurantToppingsData>[];
      json['toppings'].forEach((v) {
        toppings!.add(RestaurantToppingsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['customisation_id'] = customisationId;
    data['customisation_title'] = customisationTitle;
    data['item_name'] = itemName;
    data['item_count'] = itemCount;
    data['type'] = type;
    data['price'] = price;
    data['item_image'] = itemImage;
    data['item_thumbnail'] = itemThumbnail;
    data['kot_no'] = kotNo;
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantToppingsData {
  int? id;
  int? restaurantId;
  String? title;
  String? type;
  num? price;
  String? createdAt;
  String? updatedAt;

  RestaurantToppingsData(
      {this.id,
        this.restaurantId,
        this.title,
        this.type,
        this.price,
        this.createdAt,
        this.updatedAt});

  RestaurantToppingsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    title = json['title'];
    type = json['type'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['title'] = title;
    data['type'] = type;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

