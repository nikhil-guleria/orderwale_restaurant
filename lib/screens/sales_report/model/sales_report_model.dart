class SalesReportModel {
  Report? report;

  SalesReportModel({this.report});

  SalesReportModel.fromJson(Map<String, dynamic> json) {
    report =
    json['report'] != null ?  Report.fromJson(json['report']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (report != null) {
      data['report'] = report!.toJson();
    }
    return data;
  }
}

class Report {
  String? todaySales;
  String? monthlyEarning;
  String? todayOrders;
  String? monthlyDateOrders;
// below are used in sales report view
  String? balance;
  String? thisMonthSales;
  String? thisMonthOrders;
  String? totalSales;
  String? totalOrders;
  String? earning;
  String? dateOrders;
  int? paymentGateWay;
  int? withdrawalStatus; // 0=no request, 1=pending, 2=accepted, 3=declined
  int? withdrawalId;

  Report(
      {this.earning,
        this.todaySales,
        this.monthlyEarning,
        this.thisMonthSales,
        this.totalSales,
        this.todayOrders,
        this.dateOrders,
        this.monthlyDateOrders,
        this.thisMonthOrders,
        this.balance,
        this.totalOrders,
        this.paymentGateWay,
        this.withdrawalStatus,
        this.withdrawalId});

  Report.fromJson(Map<String, dynamic> json) {
    earning = json['earning']?? "0.0";
    todaySales = json['today_sales']?? "0.0";
    monthlyEarning = json['monthly_earning']?? "0.0";
    thisMonthSales = json['this_month_sales'] ?? "0.0";
    totalSales = json['total_sales']?? "0.0";
    todayOrders = json['today_orders']?? "0.0";
    dateOrders = json['date_orders'] ?? "0.0";
    monthlyDateOrders = json['monthly_date_orders']?? "0.0";
    thisMonthOrders = json['this_month_orders']?? "0.0";
    totalOrders = json['total_orders']?? "0.0";
    balance = json['balance'] ?? "0";
    paymentGateWay = json['payment_gateway'] ?? 0;
    withdrawalStatus = json['withdrawalStatus'] ?? 0;
    withdrawalId = json['withdrawalId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['earning'] = earning;
    data['today_sales'] = todaySales;
    data['monthly_earning'] = monthlyEarning;
    data['this_month_sales'] = thisMonthSales;
    data['total_sales'] = totalSales;
    data['today_orders'] = todayOrders;
    data['date_orders'] = dateOrders;
    data['monthly_date_orders'] = monthlyDateOrders;
    data['this_month_orders'] = thisMonthOrders;
    data['total_orders'] = totalOrders;
    data['balance']  =  balance ;
    return data;
  }
}
