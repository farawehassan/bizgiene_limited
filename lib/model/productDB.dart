/// A class to hold my [Product] model
class Product {
  /// Setting constructor for [Product] class
  Product({
    this.id,
    this.productName,
    this.costPrice,
    this.sellingPrice,
    this.initialQuantity,
    this.currentQuantity,
    this.createdAt,
    this.updatedAt
  });

  /// A string variable to hold my product id
  String id;

  /// A string variable to hold my product name
  String productName;

  /// A string variable to hold my cost price
  String costPrice;

  /// A string variable to hold my selling price
  String sellingPrice;

  /// A string variable to hold my initial quantity
  String initialQuantity;

  /// A string variable to hold my current quantity
  String currentQuantity;

  /// A string variable to hold the created at time
  String createdAt;

  /// A string variable to hold the updated at time
  String updatedAt;

  /// Creating a method to map my JSON values to the model details accordingly
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"].toString(),
      productName: json["productName"].toString(),
      costPrice: json["costPrice"].toString(),
      sellingPrice: json["sellingPrice"].toString(),
      initialQuantity: json["initialQty"].toString(),
      currentQuantity: json["currentQty"].toString(),
      createdAt: json["createdAt"].toString(),
      updatedAt: json["updatedAt"].toString(),
    );
  }

}
