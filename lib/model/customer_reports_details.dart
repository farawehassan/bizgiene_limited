/// A class to hold my [CustomerReportDetails] model
class CustomerReportDetails {

  /// Setting constructor for [CustomerReportDetails] class
  CustomerReportDetails({
    this.quantity,
    this.productName,
    this.costPrice,
    this.unitPrice,
    this.totalPrice
  });

  /// A string variable to hold quantity
  String quantity;

  /// A string variable to hold product name
  String productName;

  /// A string variable to hold cost price
  String costPrice;

  /// A string variable to hold unit price
  String unitPrice;

  /// A string variable to hold total price
  String totalPrice;

  /// Creating a method to map my JSON values to the model details accordingly
  factory CustomerReportDetails.fromJson(Map<String, dynamic> json) => CustomerReportDetails(
    quantity: json["quantity"],
    productName: json["productName"],
    costPrice: json["costPrice"],
    unitPrice: json["unitPrice"],
    totalPrice: json["totalPrice"],
  );


  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "productName": productName,
    "costPrice": costPrice,
    "unitPrice": unitPrice,
    "totalPrice": totalPrice,
  };

}