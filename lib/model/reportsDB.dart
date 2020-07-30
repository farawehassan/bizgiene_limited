/// A class to hold my [Reports] model
class Reports {

  /// Setting constructor for [Reports] class
  Reports({
    this.id,
    this.customerName,
    this.quantity,
    this.productName,
    this.costPrice,
    this.unitPrice,
    this.totalPrice,
    this.paymentMode,
    this.createdAt
  });

  /// A string variable to hold id
  String id;

  /// A string variable to hold customer name
  String customerName;

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
  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      id: json["_id"].toString(),
      customerName: json["customerName"].toString(),
      quantity: json["quantity"].toString(),
      productName: json["productName"].toString(),
      costPrice: json["costPrice"].toString(),
      unitPrice: json["unitPrice"].toString(),
      totalPrice: json["totalPrice"].toString(),
      paymentMode: json["paymentMode"].toString(),
      createdAt: json["createdAt"].toString(),
    );
  }

}