/// A class to hold my [SupplyProducts] model
class SupplyProducts {

  /// A string variable to hold my quantity
  String qty;

  /// A string variable to hold my product name
  String name;

  /// A string variable to hold my unit price
  String unitPrice;

  /// A string variable to hold my total price
  String totalPrice;

  /// Constructor for [SupplyProducts] class
  SupplyProducts({
    this.qty,
    this.name,
    this.unitPrice,
    this.totalPrice
  });

  /// Creating a method to map my JSON values to the model details accordingly
  factory SupplyProducts.fromJson(Map<String, dynamic> json) {
    return SupplyProducts(
      qty: json["qty"].toString(),
      name: json["name"].toString(),
      unitPrice: json["unitPrice"].toString(),
      totalPrice: json["totalPrice"].toString(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "qty": this.qty,
      "name": this.name,
      "unitPrice": this.unitPrice,
      "totalPrice": this.totalPrice
    };
  }

}