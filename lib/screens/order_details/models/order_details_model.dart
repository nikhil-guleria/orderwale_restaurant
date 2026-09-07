class OrderDetailsModel {
  int? code;
  String? message;
  OrderDetailsData? result;

  OrderDetailsModel({this.code, this.message, this.result});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
    json['result'] != null ? OrderDetailsData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class OrderDetailsData {
  String? orderId;
  int? userType;
  String? name;
  String? userName;
  String? deliveryAddress;
  String? latitude;
  String? longitude;
  String? phone;
  String? discountPrice;
  String? bannerImage;
  String? bannerThumbnail;
  String? address;
  String? restaurantAddress;
  String? restaurantPhone;
  String? fssaiNo;
  String? orderStatus;
  String? deliveryType;
  String? itemsTotal;
  String? totalPrice;
  String? roundOff;
  String? appliedTaxes;
  String? gst;
  String? packagingCharges;
  String? platformFee;
  String? tipPrice;
  String? adminCharge;
  String? deliveryCharge;
  String? walletPrice;
  String? paymentType;
  String? driverId;
  String? created;
  String? deliveryDateTime;
  List<Products>? products;


  OrderDetailsData(
      {this.orderId,
        this.userType,
        this.name,
        this.userName,
        this.deliveryAddress,
        this.latitude,
        this.longitude,
        this.phone,
        this.discountPrice,
        this.bannerImage,
        this.bannerThumbnail,
        this.address,
        this.restaurantAddress,
        this.restaurantPhone,
        this.fssaiNo,
        this.orderStatus,
        this.deliveryType,
        this.itemsTotal,
        this.totalPrice,
        this.roundOff,
        this.appliedTaxes,
        this.gst,
        this.packagingCharges,
        this.platformFee,
        this.tipPrice,
        this.adminCharge,
        this.deliveryCharge,
        this.walletPrice,
        this.paymentType,
        this.driverId,
        this.created,
        this.deliveryDateTime,
        this.products});

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    userType = json['user_type'];
    name = json['name'];
    userName = json['user_name'];
    deliveryAddress = json['delivery_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    discountPrice = json['discount_price'];
    bannerImage = json['banner_image'];
    bannerThumbnail = json['banner_thumbnail'];
    address = json['address'];
    restaurantAddress = json['restaurant_address'];
    restaurantPhone = json['restaurant_phone'];
    fssaiNo = json['fssai_no'];
    orderStatus = json['order_status'];
    deliveryType = json['delivery_type'];
    itemsTotal = json['items_total'];
    totalPrice = json['total_price'];
    roundOff = json['round_off'];
    appliedTaxes = json['applied_taxes'];
    gst = json['gst'];
    packagingCharges = json['packaging_charges'];
    platformFee = json['platform_fee'];
    tipPrice = json['tip_price'];
    adminCharge = json['admin_charge'];
    deliveryCharge = json['delivery_charge'];
    walletPrice = json['wallet_price'];
    paymentType = json['payment_type'];
    driverId = json['driver_id'];
    created = json['created'];
    deliveryDateTime = json['delivery_date_time'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['user_type'] = userType;
    data['name'] = name;
    data['user_name'] = userName;
    data['delivery_address'] = deliveryAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    data['discount_price'] = discountPrice;
    data['banner_image'] = bannerImage;
    data['banner_thumbnail'] = bannerThumbnail;
    data['address'] = address;
    data['restaurant_address'] = restaurantAddress;
    data['restaurant_phone'] = restaurantPhone;
    data['fssai_no'] = fssaiNo;
    data['order_status'] = orderStatus;
    data['delivery_type'] = deliveryType;
    data['items_total'] = itemsTotal;
    data['total_price'] = totalPrice;
    data['round_off'] = roundOff;
    data['applied_taxes'] = appliedTaxes;
    data['gst'] = gst;
    data['packaging_charges'] = packagingCharges;
    data['platform_fee'] = platformFee;
    data['tip_price'] = tipPrice;
    data['admin_charge'] = adminCharge;
    data['delivery_charge'] = deliveryCharge;
    data['wallet_price'] = walletPrice;
    data['payment_type'] = paymentType;
    data['driver_id'] = driverId;
    data['created'] = created;
    data['delivery_date_time'] = deliveryDateTime;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  int? status;
  int? kotNo;
  int? customisationId;
  String? customisationTitle;
  String? productName;
  String? productPrice;
  String? productQuantity;
  String? extraNote;
  String? type;
  String? discount;
  String? price;
  String? description;
  String? image;
  String? thumbnail;
  List<Toppings>? toppings;


  Products(
      {this.id,
        this.status,
        this.kotNo,
        this.customisationId,
        this.customisationTitle,
        this.productName,
        this.productPrice,
        this.productQuantity,
        this.extraNote,
        this.type,
        this.discount,
        this.price,
        this.description,
        this.image,
        this.thumbnail,
        this.toppings});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    kotNo = json['kot_no'];
    customisationId = json['customisation_id'];
    customisationTitle = json['customisation_title'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    productQuantity = json['product_quantity'];
    extraNote = json['extra_note'];
    type = json['type'];
    discount = json['discount'];
    price = json['price'];
    description = json['description'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(Toppings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['kot_no'] = kotNo;
    data['customisation_id'] = customisationId;
    data['customisation_title'] = customisationTitle;
    data['product_name'] = productName;
    data['product_price'] = productPrice;
    data['product_quantity'] = productQuantity;
    data['extra_note'] = extraNote;
    data['type'] = type;
    data['discount'] = discount;
    data['price'] = price;
    data['description'] = description;
    data['image'] = image;
    data['thumbnail'] = thumbnail;
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Toppings {
  int? id;
  int? restaurantId;
  String? title;
  String? type;
  num? price;
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

