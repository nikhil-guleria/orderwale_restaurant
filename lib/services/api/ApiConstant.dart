import 'package:flutter/foundation.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

class ApiConstant {
  static const String androidKey = "AIzaSyDbMgAfj0CBFCQWrOr4L57i_bXztoGiyPU";
  static const String razorPayId =   kReleaseMode ? 'rzp_live_Xz54l3nZV0bijT' : 'rzp_test_yBysEoo7n7YwkE';
  static const cfEnvironment = kReleaseMode ? CFEnvironment.PRODUCTION : CFEnvironment.SANDBOX;
}