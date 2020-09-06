import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/customerDB.dart';
import 'package:bizgienelimited/model/customer_reports.dart';
import 'package:bizgienelimited/model/customer_reports_details.dart';
import 'package:bizgienelimited/model/productDB.dart';
import 'package:bizgienelimited/model/create_user.dart';
import 'package:bizgienelimited/model/product_history.dart';
import 'package:bizgienelimited/model/product_history_details.dart';
import 'package:bizgienelimited/model/reportsDB.dart';
import 'package:bizgienelimited/model/store_details.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/model/user.dart';
import 'network_util.dart';

/// A [RestDataSource] class to do all the send request to the back end
/// and handle the result
class RestDataSource {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Instantiating a class of the [NetworkHelper]
  NetworkHelper _netUtil = new NetworkHelper();

  static final BASE_URL = "https://bizgenie-limited.herokuapp.com";

  static final LOGIN_URL = BASE_URL + "/authentication/login";
  static final SIGN_UP_URL = BASE_URL + "/authentication/signup";

  static final ADD_PRODUCT_URL = BASE_URL + "/product/addProduct";
  static final UPDATE_PRODUCT_URL = BASE_URL + "/product/editProduct";
  static final FETCH_PRODUCTS_URL = BASE_URL + "/product/fetchAllProducts";
  static final FETCH_PRODUCT_URL = BASE_URL + "/product/fetchProduct";

  static final ADD_REPORT_URL = BASE_URL + "/report/addNewReport";
  static final UPDATE_REPORT_NAME_URL = BASE_URL + "/report/updateReportName";
  static final FETCH_REPORT_URL = BASE_URL + "/report/fetchAllReports";
  static final DELETE_REPORT_URL = BASE_URL + "/report/deleteReport";

  static final FETCH_STORE_URL = BASE_URL + "/fetchStoreDetails";

  static final ADD_SUPPLY_URL = BASE_URL + "/supply/addNewSupply";
  static final RECEIVED_SUPPLY_URL = BASE_URL + "/supply/receivedSupply";
  static final UPDATE_SUPPLY_URL = BASE_URL + "/supply/editSupply";
  static final FETCH_SUPPLIES_URL = BASE_URL + "/supply/fetchAllSupplies";
  static final FETCH_SUPPLY_URL = BASE_URL + "/supply/fetchSupply";
  static final DELETE_SUPPLY_URL = BASE_URL + "/supply/deleteSupply";

  static final ADD_CUSTOMER_URL = BASE_URL + "/customer/addNewCustomer";
  static final ADD_CUSTOMER_REPORT_URL = BASE_URL + "/customer/addNewCustomerReports";
  static final UPDATE_CUSTOMER_REPORT_URL = BASE_URL + "/customer/updateCustomerReport";
  static final UPDATE_PAYMENT_CUSTOMER_URL = BASE_URL + "/customer/updatePaymentMadeReport";
  static final SETTLE_PAYMENT_CUSTOMER_URL = BASE_URL + "/customer/settlePaymentReport";
  static final FETCH_CUSTOMERS_URL = BASE_URL + "/customer/fetchAllCustomers";
  static final FETCH_CUSTOMER_URL = BASE_URL + "/customer/fetchCustomer";
  static final DELETE_CUSTOMER_URL = BASE_URL + "/customer/deleteCustomer";
  static final DELETE_CUSTOMER_REPORT_URL = BASE_URL + "/customer/deleteCustomerReport";

  static final ADD_PRODUCT_HISTORY_URL = BASE_URL + "/history/addProductHistory";
  static final ADD_HISTORY_TO_PRODUCT_URL = BASE_URL + "/history/addNewProductToHistory";
  static final FETCH_PRODUCT_HISTORY_URL = BASE_URL + "/history/fetchProductHistory";
  static final FIND_PRODUCT_HISTORY_URL = BASE_URL + "/history/findProductHistory";
  static final UPDATE_PRODUCT_HISTORY_NAME_URL = BASE_URL + "/history/updateProductName";
  static final DELETE_PRODUCT_HISTORY_URL = BASE_URL + "/history/deleteHistory";

  /// A function that verifies login details from the database POST.
  /// with [phoneNumber] and [pin]
  Future<User> login(String phoneNumber, String pin) {
    return _netUtil.postLogin(LOGIN_URL, body: {
      "phone": phoneNumber,
      "password": pin
    }).then((dynamic res) {
      if(res["error"] == true){
        print(res["error"]);
        throw (res["message"]);
      } else {
        print(res["error"]);
        return User.map(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw (e);
    });
  }

  /// A function that creates a new user POST.
  /// with [CreateUser] model
  Future<dynamic> signUp(CreateUser createUser) {
    return _netUtil.post(SIGN_UP_URL, body: {
      "name": createUser.name,
      "phone": createUser.phoneNumber,
      "type": "Worker",
      "password": createUser.pin,
      "confirmPassword": createUser.confirmPin
    }).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in creating user, try again");
    });
  }

  /// A function that adds new product to the database POST
  /// with [Product] model
  Future<dynamic> addProduct(Product product) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });

    return _netUtil.post(ADD_PRODUCT_URL, headers: header, body: {
      "productName": product.productName,
      "costPrice": product.costPrice.toString(),
      "sellingPrice": product.sellingPrice.toString(),
      "initialQty": product.initialQuantity.toString(),
      "currentQty": product.currentQuantity.toString(),
      "createdAt": product.createdAt.toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding product, try again");
    });
  }

  /// A function that updates product details PUT.
  /// with [Product]
  Future<dynamic> updateProduct(Product product, String id) async{
    /// Variable holding today's datetime
    DateTime dateTime = DateTime.now();

    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final UPDATE_URL = UPDATE_PRODUCT_URL + "/$id";

    return _netUtil.put(UPDATE_URL, headers: header, body: {
      "productName": product.productName,
      "costPrice": product.costPrice.toString(),
      "sellingPrice": product.sellingPrice.toString(),
      "initialQty": product.initialQuantity.toString(),
      "currentQty": product.currentQuantity.toString(),
      "updatedAt":  dateTime.toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating product, try again");
    });
  }

  /// A function that fetches a particular product from the database
  /// into a model of [Product] GET.
  Future<Product> fetchProduct(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    final FETCH_URL = FETCH_PRODUCT_URL + "/$id";
    return _netUtil.get(FETCH_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return Product.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching product, try again");
    });
  }

  /// A function that fetches all products from the database
  /// into a List of [Product] GET.
  Future<List<Product>> fetchAllProducts() async {
    List<Product> products;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw new Exception("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_PRODUCTS_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var rest = res["data"] as List;
        products = rest.map<Product>((json) => Product.fromJson(json)).toList();
        return products;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching products, try again");
    });
  }

  /// A function that adds new daily reports to the database POST.
  /// with [Reports] model
  Future<dynamic> addNewDailyReport(Reports reportsData) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });

    return _netUtil.post(ADD_REPORT_URL, headers: header, body: {
      "customerName": reportsData.customerName,
      "quantity": reportsData.quantity.toString(),
      "productName": reportsData.productName,
      "costPrice": reportsData.costPrice.toString(),
      "unitPrice": reportsData.unitPrice.toString(),
      "totalPrice": reportsData.totalPrice.toString(),
      "paymentMode": reportsData.paymentMode.toString(),
      "createdAt": reportsData.createdAt.toString()
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in saving ${reportsData.productName}, try again");
    });
  }

  /// A function that updates report product name to the server PUT.
  /// with [Reports] model
  Future<dynamic> updateReportName(String productName, String updatedName) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });

    return _netUtil.put(UPDATE_REPORT_NAME_URL, headers: header, body: {
      "productName": productName,
      "updatedName": updatedName,
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating $productName, try again");
    });
  }

  /// A function that fetches all reports from the database
  /// into a List of [Reports] GET.
  Future<List<Reports>> fetchAllReports() async {
    List<Reports> reports;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_REPORT_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var result = res["data"] as List;
        reports = result.map<Reports>((json) => Reports.fromJson(json)).toList();
        return reports;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching reports, try again");
    });
  }

  /// A function that deletes a report from the server using the [time]
  Future<dynamic> deleteReport(String time, String customerName, String productName) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final DELETE_URL = DELETE_REPORT_URL + "/$time/$customerName/$productName";
    return _netUtil.delete(DELETE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting report, try again");
    });
  }

  /// A function that fetches a the store details from the database
  /// into a model of [StoreDetails] GET.
  Future<StoreDetails> fetchStoreDetails() async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_STORE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return StoreDetails.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching store details, try again");
    });
  }

  /// A function that adds new supply to the database POST
  /// with [Supply] model
  Future<dynamic> addSupply(Supply supply) async{
    Map<String, String> header;
    Map<String, dynamic> jsonBody;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
      supply.foc
          ? jsonBody = {
        "dealer": supply.dealer.toString(),
        "amount": supply.amount.toString(),
        "foc": supply.foc.toString(),
        "focRate": supply.focRate.toString(),
        "focPayment": supply.focPayment.toString(),
        "notes": supply.notes.toString(),
        "received": supply.received.toString(),
        "createdAt": supply.createdAt.toString(),
      }
          : jsonBody = {
        "dealer": supply.dealer.toString(),
        "amount": supply.amount.toString(),
        "foc": supply.foc.toString(),
        "notes": supply.notes.toString(),
        "received": supply.received.toString(),
        "createdAt": supply.createdAt.toString(),
      };
    });
    return _netUtil.post(ADD_SUPPLY_URL, headers: header, body: jsonBody
    ).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding supply, try again");
    });
  }

  /// A function that updates supply details PUT.
  /// with [Supply]
  Future<dynamic> updateSupply(Supply supply) async{
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(UPDATE_SUPPLY_URL, headers: header, body: {
      "id": supply.id,
      "dealer": supply.dealer.toString(),
      "amount": supply.amount.toString(),
      "notes": supply.notes,
      "received": supply.received,
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating supply, try again");
    });
  }

  /// A function that updates received in supply details to True PUT.
  /// with [Supply]
  Future<dynamic> receivedSupply(String id, bool received) async{
    /// Variable holding today's datetime
    DateTime dateTime = DateTime.now();

    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(RECEIVED_SUPPLY_URL, headers: header, body: {
      "id": id,
      "received": received.toString(),
      "receivedAt": dateTime.toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating supply, try again");
    });
  }

  /// A function that fetches a particular supply from the database
  /// into a model of [Supply] GET.
  Future<Supply> fetchSupply(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    final FETCH_URL = FETCH_SUPPLY_URL + "/$id";
    return _netUtil.get(FETCH_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return Supply.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching supply, try again");
    });
  }

  /// A function that fetches all supplies from the database
  /// into a List of [Supply] GET.
  Future<List<Supply>> fetchAllSupply() async {
    List<Supply> supplies;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_SUPPLIES_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var rest = res["data"] as List;
        supplies = rest.map<Supply>((json) => Supply.fromJson(json)).toList();
        return supplies;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      print(e);
      throw ("Error in fetching supplies, try again");
    });
  }

  /// A function that deletes a supply from the database using the [id]
  Future<dynamic> deleteSupply(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final DELETE_URL = DELETE_SUPPLY_URL + "/$id";
    return _netUtil.delete(DELETE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting supply, try again");
    });
  }

  /// A function that adds new customer to the database POST
  /// with [Customer] model
  Future<dynamic> addCustomer(Customer customer, CustomerReport customerReport) async {
    Map<String, String> header;
    Map<String, dynamic> jsonBody;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
      customerReport.paid
          ? jsonBody = {
        "name": customer.name.toString(),
        "phone": customer.phone.toString(),
        "report": jsonEncode(customerReport.reportDetails),
        "totalAmount": customerReport.totalAmount,
        "paymentMade": customerReport.paymentMade,
        "paid": customerReport.paid.toString(),
        "soldAt": customerReport.soldAt,
        "paymentReceivedAt": customerReport.paymentReceivedAt,
        "createdAt": customer.createdAt.toString(),
      }
          : jsonBody = {
        "name": customer.name.toString(),
        "phone": customer.phone.toString(),
        "report": jsonEncode(customerReport.reportDetails),
        "totalAmount": customerReport.totalAmount,
        "paymentMade": customerReport.paymentMade,
        "paid": customerReport.paid.toString(),
        "soldAt": customerReport.soldAt,
        "dueDate": customerReport.dueDate,
        "createdAt": customer.createdAt.toString(),
      };
    });
    return _netUtil.post(ADD_CUSTOMER_URL, headers: header, body: jsonBody
    ).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding customer, try again");
    });
  }

  /// A function that adds new reports to a customer reports details POST.
  /// with [CustomerReport]
  Future<dynamic> addCustomerReports(String id, CustomerReport customerReport) async {
    Map<String, String> header;
    Map<String, dynamic> jsonBody;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
      customerReport.paid
          ? jsonBody = {
              "id" : id,
              "report": jsonEncode(customerReport.reportDetails),
              "totalAmount": customerReport.totalAmount,
              "paymentMade": customerReport.paymentMade,
              "paid": customerReport.paid.toString(),
              "soldAt": customerReport.soldAt,
              "paymentReceivedAt": customerReport.paymentReceivedAt,
            }
          : jsonBody = {
              "id" : id,
              "report": jsonEncode(customerReport.reportDetails),
              "totalAmount": customerReport.totalAmount,
              "paymentMade": customerReport.paymentMade,
              "paid": customerReport.paid.toString(),
              "soldAt": customerReport.soldAt,
              "dueDate": customerReport.dueDate,
            };
    });
    print(customerReport.toString());
    return _netUtil.post(ADD_CUSTOMER_REPORT_URL, headers: header, body: jsonBody
    ).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding reports to customer, try again");
    });
  }

  /// A function that updates a particular report details of a customer PUT.
  Future<dynamic> updateCustomerReport(
      String customerId, String reportId,
      List<CustomerReportDetails> report,
      String totalAmount, String paymentMade) async{

    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(UPDATE_CUSTOMER_REPORT_URL, headers: header, body: {
      "id": customerId,
      "reportId": reportId,
      'report': report,
      'totalAmount': totalAmount,
      'paymentMade': paymentMade
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating customer\'s report, try again");
    });
  }


  /// A function that updates a particular report payment details of a customer
  /// PUT.
  Future<dynamic> updatePaymentMadeReport(
      String customerId, String reportId, String payment) async{

    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(UPDATE_PAYMENT_CUSTOMER_URL, headers: header, body: {
      "id": customerId,
      "reportId": reportId,
      'payment': payment
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in updating customer\'s payment, try again");
    });
  }

  /// A function that settles a particular report payment details of a customer
  /// PUT.
  Future<dynamic> settlePaymentReport(
      String customerId, String reportId, String payment) async{

    /// Variable holding today's datetime
    DateTime dateTime = DateTime.now();
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(SETTLE_PAYMENT_CUSTOMER_URL, headers: header, body: {
      "id": customerId,
      "reportId": reportId,
      'payment': payment,
      'paymentReceivedAt': dateTime.toString()
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in settling customer\'s payment, try again");
    });
  }

  /// A function that fetches a particular customer from the database
  /// into a model of [Customer] GET.
  Future<Customer> fetchCustomer(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    final FETCH_URL = FETCH_CUSTOMER_URL + "/$id";
    return _netUtil.get(FETCH_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return Customer.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching customer, try again");
    });
  }

  /// A function that fetches all customers from the database
  /// into a List of [Customer] GET.
  Future<List<Customer>> fetchAllCustomers() async {
    List<Customer> customers;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_CUSTOMERS_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var rest = res["data"] as List;
        customers = rest.map<Customer>((json) => Customer.fromJson(json)).toList();
        return customers;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      print(e);
      throw ("Error in fetching customers, try again");
    });
  }

  /// A function that deletes a customer from the database using the customer[id]
  Future<dynamic> deleteCustomer(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final DELETE_URL = DELETE_CUSTOMER_URL + "/$id";
    return _netUtil.delete(DELETE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting customer, try again");
    });
  }

  /// A function that deletes a customer's report from the database using the
  /// report [id]
  Future<dynamic> deleteCustomerReport(String customerId, String reportId) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(DELETE_CUSTOMER_REPORT_URL, headers: header, body: {
      "customerId": customerId,
      "reportId": reportId,
    }).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting customer's report, try again");
    });
  }

  /// A function that adds new product history to the database POST
  /// with [ProductHistoryDetails] model
  Future<dynamic> addProductHistory(String productName, ProductHistoryDetails productHistoryDetails) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.post(ADD_PRODUCT_HISTORY_URL, headers: header, body: {
      "productName": productName,
      "initialQty": productHistoryDetails.initialQty,
      "qtyReceived": productHistoryDetails.qtyReceived,
      "currentQty": productHistoryDetails.currentQty,
      "collectedAt": productHistoryDetails.collectedAt,
      "createdAt": DateTime.now().toString(),
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding product history, try again");
    });
  }

  /// A function that adds new reports to a customer reports details POST.
  /// with [ProductHistoryDetails]
  Future<dynamic> addHistoryToProduct(String id, ProductHistoryDetails productHistoryDetails) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.post(ADD_HISTORY_TO_PRODUCT_URL, headers: header, body: {
      "id": id,
      "initialQty": productHistoryDetails.initialQty,
      "qtyReceived": productHistoryDetails.qtyReceived,
      "currentQty": productHistoryDetails.currentQty,
      "collectedAt": productHistoryDetails.collectedAt,
    }).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in adding history to product history, try again");
    });
  }

  /// A function that fetches a particular product history from the database
  /// into a model of [ProductHistory] GET.
  Future<ProductHistory> findProductHistory(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    final FETCH_URL = FIND_PRODUCT_HISTORY_URL + "/$id";
    return _netUtil.get(FETCH_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        return ProductHistory.fromJson(res["data"]);
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in fetching product history, try again");
    });
  }

  /// A function that fetches all product history from the database
  /// into a List of [ProductHistory] GET.
  Future<List<ProductHistory>> fetchAllProductHistory() async {
    List<ProductHistory> history;
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}"};
    });
    return _netUtil.get(FETCH_PRODUCT_HISTORY_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        var rest = res["data"] as List;
        history = rest.map<ProductHistory>((json) => ProductHistory.fromJson(json)).toList();
        return history;
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      print(e);
      throw ("Error in fetching product history, try again");
    });
  }

  /// A function that updates a product history name from the database using the [id]
  /// and the [name] to be updated to  PUT
  Future<dynamic> updateProductHistoryName(String id, String name) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    return _netUtil.put(UPDATE_PRODUCT_HISTORY_NAME_URL, headers: header, body: {
      "id": id,
      "name": name,
    }).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting product history, try again");
    });
  }

  /// A function that deletes a product history from the database using the [id]
  Future<dynamic> deleteProductHistory(String id) async {
    Map<String, String> header;
    Future<User> user = futureValue.getCurrentUser();
    await user.then((value) {
      if(value.token == null){
        throw ("No user logged in");
      }
      header = {"Authorization": "Bearer ${value.token}", "Accept": "application/json"};
    });
    final DELETE_URL = DELETE_PRODUCT_HISTORY_URL + "/$id";
    return _netUtil.delete(DELETE_URL, headers: header).then((dynamic res) {
      if(res["error"] == true){
        throw (res["message"]);
      }else{
        print(res["message"]);
        return res["message"];
      }
    }).catchError((e){
      print(e);
      if(e is SocketException){
        throw ("Unable to connect to the server, check your internet connection");
      }
      throw ("Error in deleting product history, try again");
    });
  }

}