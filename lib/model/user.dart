/// A class to hold my [User] model
class User {

  /// A string variable to hold id
  String _id;

  /// A string variable to hold name
  String _name;

  /// A string variable to hold phone number
  String _phoneNumber;

  /// A string variable to hold account type
  String _type;

  /// A string variable to hold the date the user was created
  String _createdAt;

  /// A string variable to hold the user's login token
  String _token;

  /// Setting constructor for [User] class
  User(this._id ,this._name, this._phoneNumber, this._type, this._createdAt, this._token);

  /// Function to map user's details from a JSON object
  User.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj["name"];
    this._phoneNumber = obj["phone"];
    this._type = obj["type"];
    this._createdAt = obj["createdAt"];
    this._token = obj["token"];
  }

  /// Creating getters for my [_id] value
  String get id => _id;

  /// Creating getters for my [_name] value
  String get name => _name;

  /// Creating getters for my [_phoneNumber] value
  String get phoneNumber => _phoneNumber;

  /// Creating getters for my [_type] value
  String get type => _type;

  /// Creating getters for my [_created_at] value
  String get createdAt => _createdAt;

  /// Creating getters for my [_token] value
  String get token => _token;

  /// Function to map user's details to a JSON object
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["phone"] = _phoneNumber;
    map["type"] = _type;
    map["createdAt"] = _createdAt;
    map["token"] = _token;

    return map;
  }
}