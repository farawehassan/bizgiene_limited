
/// A class to hold my [Supply] model
class Supply {
  /// Setting constructor for [Supply] class
  Supply({
    this.id,
    this.dealer,
    this.amount,
    this.foc,
    this.focRate,
    this.focPayment,
    this.notes,
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

  /// A boolean variable to hold the supply type if foc or not
  bool foc;

  /// A string variable to hold the foc rate
  String focRate;

  /// A string variable to hold the foc payment
  String focPayment;

  /// A string variable to hold the extra notes
  String notes;

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
      foc: json["foc"],
      focRate: json["focRate"].toString(),
      focPayment: json["focPayment"].toString(),
      notes: json["notes"],
      received: json["received"],
      createdAt: json["createdAt"].toString(),
      receivedAt: json["receivedAt"].toString(),
    );
  }

}