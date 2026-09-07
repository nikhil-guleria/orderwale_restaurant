
import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_color.dart';

class SetUpOrdersData {
  static final SetUpOrdersData stUP = SetUpOrdersData._internal();
  factory SetUpOrdersData() {
    return stUP;
  }

  SetUpOrdersData._internal();

  String setUpOrderStatus(String status) {
    switch (status) {
      case "1":
        return "New Order"; // received
      case "2":
        return "Preparing";// accepted
      case "3":
        return "Declined";
      case "4":
        return "Out for Delivery"; //order on the way
      case "5":
        return "Delivered";
      case "6":
        return "Out For Delivery";
      case "9":
        return "Cancelled";
      case "7":
        return "Ready";
      default:
        return "N/A";
    }
  }





   LinearGradient setUpButtonColor(String status) {
    switch (status) {
      case "1":
        return const LinearGradient(
          colors: [ Colors.purple,
            Colors.blue,],
        );
      case "2":
        return const LinearGradient(
          colors: [ colorPrimary,
            colorPrimary,],
        );
      case "3":
        return const LinearGradient(
          colors: [ Colors.redAccent,
            Colors.redAccent,],
        );
      case "4":
        return const LinearGradient(
          colors: [ Colors.blueGrey,
            Colors.blueGrey],
        );
      case "5":
        return const LinearGradient(
          colors: [ Colors.green,
            Colors.green,],
        );
      case "6":
        return const LinearGradient(
          colors: [ Colors.purpleAccent,
            Colors.purpleAccent,],
        );
      case "9":
        return const LinearGradient(
          colors: [ Colors.red,
            Colors.red,],
        );
      case "7":
        return const LinearGradient(
          colors: [ Colors.blueAccent,
            Colors.blueAccent],
        );
      default:
        return const LinearGradient(
          colors: [ colorPrimary,
            colorPrimary],
        );
    }
  }


  setCardType(String type) {
    if (type == "1") {
      return 'COD';
    } else if (type == "2") {
      return 'Card';
    } else if (type == "4") {
      return 'RazorPay';
    } else if (type == "5") {
      return 'Wallet';
    } else if (type == "6") {
      return 'PayNow';
    } else {
      return 'Paypal';
    }
  }

  Icon setCardTypeIcon(String type) {
    if (type == "1") {
      return const Icon(
        Icons.money_rounded,
        size: 20,
      );
    } else if (type == "2") {
      return const Icon(
        Icons.credit_card_rounded,
        size: 20,
      );
    } else if (type == "4") {
      return const Icon(
        Icons.credit_card_rounded,
        size: 20,
      );
    } else if (type == "5") {
      return const Icon(
        Icons.account_balance_wallet,
        size: 20,
      );
    } else if (type == "6") {
      return const Icon(
        Icons.credit_card_rounded,
        size: 20,
      );
    } else {
      return const Icon(
        Icons.credit_card_rounded,
        size: 20,
      );
    }
  }



}