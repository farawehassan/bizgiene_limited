/// A class to hold my [StoreDetails] model
class StoreDetails {
  /// A double variable to hold cost price net worth
  double cpNetWorth;

  /// A double variable to hold selling price net worth
  double spNetWorth;

  /// A double variable to hold the number of items
  double totalItems;

  /// A double variable to hold the total sales made
  double totalSalesMade;

  /// A double variable to hold the total profit made
  double totalProfitMade;

  /// Constructor for [StoreDetails] class
  StoreDetails({
    this.cpNetWorth,
    this.spNetWorth,
    this.totalItems,
    this.totalSalesMade,
    this.totalProfitMade
  });

  /// Creating a method to map my JSON values to the model details accordingly
  factory StoreDetails.fromJson(Map<String, dynamic> json) {
    return StoreDetails(
      cpNetWorth: double.parse(json["cpNetWorth"]),
      spNetWorth: double.parse(json["spNetWorth"]),
      totalItems: double.parse(json["totalItems"]),
      totalSalesMade: double.parse(json["totalSalesMade"]),
      totalProfitMade: double.parse(json["totalProfitMade"]),
    );
  }
}
