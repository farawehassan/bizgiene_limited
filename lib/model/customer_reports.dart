import 'dart:convert';
import 'customer_reports_details.dart';

/// A class to hold my [CustomerReport] model
class CustomerReport {

  /// Setting constructor for [CustomerReport] class
  CustomerReport({
    this.id,
    this.reportDetails,
    this.totalAmount,
    this.paymentMade,
    this.paid,
    this.soldAt,
    this.dueDate,
    this.paymentReceivedAt
  });

  /// A string variable to hold the id of a customer report
  String id;

  /// An object variable to hold the report details
  List<CustomerReportDetails> reportDetails;

  /// A string variable to hold the total amount of items bought
  String totalAmount;

  /// A string variable to hold the payment made
  String paymentMade;

  /// A bool variable to hold true or false if the items bought are fully paid
  bool paid;

  /// A String variable to hold the date and time the items was sold
  String soldAt;

  /// A String variable to hold date and time the payment will be due
  String dueDate;

  /// A String variable to hold the date and time the payment was received
  String paymentReceivedAt;

  factory CustomerReport.fromJson(Map<String, dynamic> json) {
    var reportsJson = jsonDecode(json['report']) as List;
    List<CustomerReportDetails> res = reportsJson.map((json) => CustomerReportDetails.fromJson(json)).toList();
    return CustomerReport(
    id: json["_id"].toString(),
    reportDetails: res,
    totalAmount: json["totalAmount"].toString(),
    paymentMade: json["paymentMade"].toString(),
    paid: json["paid"],
    soldAt: json["soldAt"].toString(),
    dueDate: json["dueDate"].toString(),
    paymentReceivedAt: json["paymentReceivedAt"].toString(),
  );
  }

  Map<String, dynamic> toJson() => {
    "report": List<dynamic>.from(reportDetails.map((x) => x.toJson())),
    "totalAmount": totalAmount,
    "paymentMade": paymentMade,
    "paid": paid,
    "soldAt": soldAt,
    "dueDate": dueDate,
  };

}