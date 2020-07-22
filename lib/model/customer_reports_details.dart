/// A class to hold my [CustomerReportDetails] model
class CustomerReportDetails {

  /// Setting constructor for [CustomerReportDetails] class
  CustomerReportDetails({
    this.quantity,
    this.productName,
    this.costPrice,
    this.unitPrice,
    this.totalPrice,
    this.paymentMode,
    this.createdAt
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

  /// A string variable to hold payment mode
  String paymentMode;

  /// A string variable to hold time
  String createdAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory CustomerReportDetails.fromJson(Map<String, dynamic> json) {
    return CustomerReportDetails(
      quantity: json["quantity"].toString(),
      productName: json["productName"].toString(),
      costPrice: json["costPrice"].toString(),
      unitPrice: json["unitPrice"].toString(),
      totalPrice: json["totalPrice"].toString(),
      paymentMode: json["paymentMode"].toString(),
      createdAt: json["createdAt"].toString(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "quantity": this.quantity,
      "productName": this.productName,
      "costPrice": this.costPrice,
      "unitPrice": this.unitPrice,
      "totalPrice": this.totalPrice,
      "paymentMode": this.paymentMode,
      "createdAt": this.createdAt
    };
  }

}