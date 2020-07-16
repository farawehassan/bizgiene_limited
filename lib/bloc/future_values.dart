import 'package:bizgienelimited/database/user_db_helper.dart';
import 'package:bizgienelimited/model/linear_sales.dart';
import 'package:bizgienelimited/model/productDB.dart';
import 'package:bizgienelimited/model/reportsDB.dart';
import 'package:bizgienelimited/model/store_details.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/model/user.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'daily_report_value.dart';

/// A class to handle my asynchronous methods linking to the server or database
class FutureValues {

  /// Method to get the current [user] in the database using the
  /// [DatabaseHelper] class
  Future<User> getCurrentUser() async {
    var dbHelper = DatabaseHelper();
    Future<User> user = dbHelper.getUser();
    return user;
  }

  /// Method to get all the products from the database in the server with
  /// the help of [RestDataSource]
  /// It returns a list of [Product]
  Future<List<Product>> getAllProductsFromDB() {
    var data = RestDataSource();
    Future<List<Product>> product = data.fetchAllProducts();
    print(product);
    return product;
  }

  /// Method to get all the products from the database in the server that its
  /// [currentQuantity] is not 0 with the help of [RestDataSource]
  /// It returns a list of [Product]
  Future<List<Product>> getAvailableProductsFromDB() async {
    List<Product> products = new List();
    Future<List<Product>> availableProduct = getAllProductsFromDB();
    await availableProduct.then((value){
      for(int i = 0; i < value.length; i++){
        if(double.parse(value[i].currentQuantity) != 0.0){
          products.add(value[i]);
        }
      }
    }).catchError((e){
      throw e;
    });
    print(products);
    return products;
  }

  /// Method to get all the products from the database in the server that its
  /// [currentQuantity] is = 0 with the help of [RestDataSource]
  /// It returns a list of [Product]
  Future<List<Product>> getFinishedProductFromDB() async {
    List<Product> products = new List();
    Future<List<Product>> finishedProduct = getAllProductsFromDB();
    await finishedProduct.then((value){
      for(int i = 0; i < value.length; i++){
        if(double.parse(value[i].currentQuantity) == 0.0){
          products.add(value[i]);
        }
      }
    }).catchError((e){
      throw e;
    });
    print(products);
    return products;
  }

  /// Method to get all the reports from the database in the server with
  /// the help of [RestDataSource]
  /// It returns a list of [Reports]
  Future<List<Reports>> getAllReportsFromDB() {
    var data = RestDataSource();
    Future<List<Reports>> dailyReportData = data.fetchAllReports();
    return dailyReportData;
  }

  /// Method to get today's reports from [DailyReportValue] based on time by
  /// calling the [getTodayReport]
  /// It returns a list of [Reports]
  Future<List<Reports>> getTodayReports() {
    var reportValue = DailyReportValue();
    Future<List<Reports>> todayReport = reportValue.getTodayReport();
    return todayReport;
  }

  /// Method to get all the store details such as:
  ///  cost price net worth, selling price net worth, number of product items,
  ///  total sales made, totalProfitMade
  /// It returns a model of [StoreDetails]
  Future<StoreDetails> getStoreDetails() async {
    var data = RestDataSource();
    Future<StoreDetails> storeDetails = data.fetchStoreDetails();
    return storeDetails;
  }

  /// Method to get all the supplies from the database in the server with
  /// the help of [RestDataSource]
  /// It returns a list of [Supply]
  Future<List<Supply>> getAllSuppliesFromDB() {
    var data = RestDataSource();
    Future<List<Supply>> supply = data.fetchAllSupply();
    print(supply);
    return supply;
  }

  /// Method to get all the supply dealer names from the database by storing all
  /// the dealer names from [getAllSuppliesFromDB()]
  /// It returns a list of [String]
  Future<List<String>> getAllSupplyNamesFromDB() async {
    List<String> names = new List();
    Future<List<Supply>> receivedSupply = getAllSuppliesFromDB();
    await receivedSupply.then((value){
      for(int i = 0; i < value.length; i++){
        names.add(value[i].dealer);
      }
    }).catchError((e){
      throw e;
    });
    print(names);
    return names;
  }

  /// Method to get all the received supplies from the database in the server with
  /// the help of [RestDataSource]
  /// It returns a list of [Supply]
  Future<List<Supply>> getReceivedSuppliesFromDB() async {
    List<Supply> supply = new List();
    Future<List<Supply>> receivedSupply = getAllSuppliesFromDB();
    await receivedSupply.then((value){
      for(int i = 0; i < value.length; i++){
        if(value[i].received == true){
          supply.add(value[i]);
        }
      }
    }).catchError((e){
      throw e;
    });
    print(supply);
    return supply;
  }

  /// Method to get all the supplies yet to be received from the database in the
  /// server with the help of [RestDataSource]
  /// It returns a list of [Supply]
  Future<List<Supply>> getInProgressSuppliesFromDB() async {
    List<Supply> supply = new List();
    Future<List<Supply>> inProgressSupply = getAllSuppliesFromDB();
    await inProgressSupply.then((value){
      for(int i = 0; i < value.length; i++){
        if(value[i].received == false){
          supply.add(value[i]);
        }
      }
    }).catchError((e){
      throw e;
    });
    print(supply);
    return supply;
  }

  /// Method to get report of a [month] using the class [DailyReportValue]
  /// /// It returns a list of [Reports]
  Future<List<Reports>> getMonthReports(String month) {
    var reportValue = DailyReportValue();

    switch(month) {
      case 'Jan': {
        Future<List<Reports>> monthReport = reportValue.getJanReport();
        return monthReport;
      }
      break;

      case 'Feb': {
        Future<List<Reports>> monthReport = reportValue.getFebReport();
        return monthReport;
      }
      break;

      case 'Mar': {
        Future<List<Reports>> monthReport = reportValue.getMarReport();
        return monthReport;
      }
      break;

      case 'Apr': {
        Future<List<Reports>> monthReport = reportValue.getAprReport();
        return monthReport;
      }
      break;

      case 'May': {
        Future<List<Reports>> monthReport = reportValue.getMayReport();
        return monthReport;
      }
      break;

      case 'Jun': {
        Future<List<Reports>> monthReport = reportValue.getJunReport();
        return monthReport;
      }
      break;

      case 'Jul': {
        Future<List<Reports>> monthReport = reportValue.getJulReport();
        return monthReport;
      }
      break;

      case 'Aug': {
        Future<List<Reports>> monthReport = reportValue.getAugReport();
        return monthReport;
      }
      break;

      case 'Sep': {
        Future<List<Reports>> monthReport = reportValue.getSepReport();
        return monthReport;
      }
      break;

      case 'Oct': {
        Future<List<Reports>> monthReport = reportValue.getOctReport();
        return monthReport;
      }
      break;

      case 'Nov': {
        Future<List<Reports>> monthReport = reportValue.getNovReport();
        return monthReport;
      }
      break;

      case 'Dec': {
        Future<List<Reports>> monthReport = reportValue.getDecReport();
        return monthReport;
      }
      break;

      default: {
        return null;
      }
      break;
    }

  }

  /// Method to get report of a year by accumulating the report of each month
  /// using the [LinearSales] model by calculating the [totalSales] as the
  /// sum of every [totalPrice] in the [DailyReportValue] and also calculating
  /// the profit using [calculateProfit()] function
  /// It returns a list of [LinearSales]
  Future<List<LinearSales>> getYearReports() async {
    List<LinearSales> sales = new List();
    var reportValue = DailyReportValue();

    Future<List<Reports>> janReport = reportValue.getJanReport();
    await janReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Jan';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> febReport = reportValue.getFebReport();
    await febReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Feb';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> marReport = reportValue.getMarReport();
    await marReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Mar';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> aprReport = reportValue.getAprReport();
    await aprReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Apr';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> mayReport = reportValue.getMayReport();
    await mayReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'May';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> junReport = reportValue.getJunReport();
    await junReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Jun';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> julReport = reportValue.getJulReport();
    await julReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Jul';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> augReport = reportValue.getAugReport();
    await augReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Aug';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> sepReport = reportValue.getSepReport();
    await sepReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Sep';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> octReport = reportValue.getOctReport();
    await octReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Oct';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> novReport = reportValue.getNovReport();
    await novReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Nov';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    Future<List<Reports>> decReport = reportValue.getDecReport();
    await decReport.then((value) async {
      LinearSales linearSales = new LinearSales();
      double totalProfitMade = 0.0;
      double totalSales = 0;
      for(int i = 0; i < value.length; i++){
        totalProfitMade += double.parse(value[i].quantity) *
            (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));
        totalSales += double.parse(value[i].totalPrice);
      }
      linearSales.month = 'Dec';
      linearSales.sales = totalSales;
      linearSales.profit = totalProfitMade;
      sales.add(linearSales);
    }).catchError((onError){
      throw (onError);
    });

    return sales;

  }

}