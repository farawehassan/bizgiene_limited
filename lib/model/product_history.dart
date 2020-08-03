import 'dart:convert';
import 'package:bizgienelimited/model/product_history_details.dart';

/// A class to hold my [ProductHistory] model
class ProductHistory {

  /// Setting constructor for [ProductHistory] class
  ProductHistory({
    this.id,
    this.productName,
    this.historyDetails,
    this.createdAt
  });

  /// A string variable to hold the id of a customer report
  String id;

  /// A string variable to hold product name
  String productName;

  /// An object variable to hold the report details
  List<ProductHistoryDetails> historyDetails;

  /// A String variable to hold the date and time the history was created
  String createdAt;

  factory ProductHistory.fromJson(Map<String, dynamic> json) {
    return ProductHistory(
      id: json["_id"].toString(),
      productName: json["productName"],
      historyDetails: List<ProductHistoryDetails>.from(json["products"].map((x) => ProductHistoryDetails.fromJson(x))),
      createdAt: json["createdAt"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "historyDetails": List<dynamic>.from(historyDetails.map((x) => x.toJson())),
    "createdAt": createdAt,
  };

}