import 'dart:convert';
import 'customer_reports_details.dart';

/// A class to hold my [CustomerReport] model
class CustomerReport {

  /// Setting constructor for [CustomerReport] class
  CustomerReport({
    this.reportDetails,
    this.totalAmount,
    this.paymentMade,
    this.paid,
    this.soldAt,
    this.dueDate,
    this.paymentReceivedAt
  });

  /// An object variable to hold the report details
  List<CustomerReportDetails> reportDetails;

  /// A string variable to hold the total amount of items bought
  String totalAmount;

  /// A string variable to hold the payment made
  String paymentMade;

  /// A bool variable to hold true or false if the items bought are fully paid
  bool paid;

  /// A string variable to hold the date and time the items was sold
  String soldAt;

  /// A string variable to hold date and time the payment will be due
  String dueDate;

  /// A string variable to hold the date and time the payment was received
  String paymentReceivedAt;


  /// Creating a method to map my JSON values to the model details accordingly
  factory CustomerReport.fromJson(Map<String, dynamic> json) {
    var reportDetailsJson = jsonDecode(json['report']) as List;
    List<CustomerReportDetails> res = reportDetailsJson.map((json) => CustomerReportDetails.fromJson(json)).toList();
    return CustomerReport(
      reportDetails: res,
      totalAmount: json["totalAmount"].toString(),
      paymentMade: json["paymentMade"].toString(),
      paid: json["paid"],
      soldAt: json["soldAt"].toString(),
      dueDate: json["dueDate"].toString(),
      paymentReceivedAt: json["paymentReceivedAt"].toString(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "report": this.reportDetails,
      "totalAmount": this.totalAmount,
      "paymentMade": this.paymentMade,
      "paid": this.paid,
      "soldAt": this.soldAt,
      "dueDate": this.dueDate,
      "paymentReceivedAt": this.paymentReceivedAt
    };
  }

}