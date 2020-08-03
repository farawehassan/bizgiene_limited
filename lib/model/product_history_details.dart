/// A class to hold my [ProductHistoryDetails] model
class ProductHistoryDetails {

  /// Setting constructor for [ProductHistoryDetails] class
  ProductHistoryDetails({
    this.initialQty,
    this.qtyReceived,
    this.currentQty,
    this.collectedAt
  });

  /// A string variable to hold initial quantity
  String initialQty;

  /// A string variable to hold initial quantity
  String qtyReceived;

  /// A string variable to hold current quantity
  String currentQty;

  /// A string variable to hold date and time these products were collected
  String collectedAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory ProductHistoryDetails.fromJson(Map<String, dynamic> json) => ProductHistoryDetails(
    initialQty: json["initialQty"].toString(),
    qtyReceived: json["qtyReceived"].toString(),
    currentQty: json["currentQty"].toString(),
    collectedAt: json["collectedAt"].toString(),
  );


  Map<String, dynamic> toJson() => {
    "initialQty": initialQty,
    "qtyReceived": qtyReceived,
    "currentQty": currentQty,
    "collectedAt": collectedAt,
  };

}