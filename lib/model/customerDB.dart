import 'customer_reports.dart';

/// A class to hold my [Customer] model
class Customer {

  /// Setting constructor for [Customer] class
  Customer({
    this.id,
    this.name,
    this.phone,
    this.reports,
    this.createdAt,
  });

  /// A string variable to hold the id of customer
  String id;

  /// A string variable to hold the name of customer
  String name;

  /// A string variable to hold the phone number name of customer
  String phone;

  /// An object variable to hold the customer reports details
  List<CustomerReport> reports;

  /// A string variable to hold the date and time the customer was created
  String createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["_id"].toString(),
    name: json["name"].toString(),
    phone: json["phone"].toString(),
    reports: List<CustomerReport>.from(json["reports"].map((x) => CustomerReport.fromJson(x))),
    createdAt: json["createdAt"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "reports": List<dynamic>.from(reports.map((x) => x.toJson())),
    "createdAt": createdAt,
  };

}