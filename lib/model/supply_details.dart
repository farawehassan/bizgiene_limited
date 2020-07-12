/// A class to hold my [Supply] model
class Supply {
  /// Setting constructor for [Supply] class
  Supply({
    this.id,
    this.dealer,
    this.amount,
    this.products,
    this.received,
    this.createdAt,
    this.receivedAt
  });

  /// A string variable to hold my supply id
  String id;

  /// A string variable to hold my dealer's name of the supply
  String dealer;

  /// A string variable to hold the amount
  String amount;

  /// An object variable to hold the product type and details
  Object products;

  /// A bool variable to hold true or false if supply is received
  bool received;

  /// A string variable to hold the created at time
  String createdAt;

  /// A string variable to hold the received at time
  String receivedAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(
      id: json["_id"].toString(),
      dealer: json["dealer"].toString(),
      amount: json["amount"].toString(),
      products: json["products"],
      received: json["received"],
      createdAt: json["createdAt"].toString(),
      receivedAt: json["receivedAt"].toString(),
    );
  }

}