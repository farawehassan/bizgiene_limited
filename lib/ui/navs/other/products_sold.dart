import 'package:bizgienelimited/bloc/daily_report_value.dart';
import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/reportsDB.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:pie_chart/pie_chart.dart';

class ProductsSold extends StatefulWidget {

  static const String id = 'products_sold';

  @override
  _ProductsSoldState createState() => _ProductsSoldState();
}

class _ProductsSoldState extends State<ProductsSold> {

  /// Instantiating a class of the [DailyReportValue]
  var reportValue = DailyReportValue();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A variable holding the list of primary colors and accents colors
  List<Color> colours = (Colors.primaries.cast<Color>() + Colors.accents.cast<Color>());

  /// A variable holding my report data as a map
  var _data = new Map();

  /// Creating a map to my [_data]'s product name to it's quantity for my charts
  Map<String, double> _dataMap = new Map();

  /// A variable holding the list of colors needed for my pie chart
  List<Color> _colorList = [];

  /// Variable to hold the total sales made
  double _totalSalesPrice = 0.0;

  /// Variable to hold the total profit made
  double _totalProfitMade = 0.0;

  /// A variable holding the length my monthly report data
  int _dataLength;

  /// Variable to hold the type of the user logged in
  String _userType;

  /// Setting the current user's type logged in to [_userType]
  void getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      _userType = user.type;
    }).catchError((Object error) {
      _showMessage(error.toString());
    });
  }

  /// Function to get this [month] report and map [_data] it's product name to
  /// its quantity accordingly
  /// It also calls the function [getColors()]
  void getReports() async {
    Future<List<Reports>> report = futureValue.getAllReportsFromDB();
    await report.then((value) {
      if (!mounted) return;
      setState(() {
        _dataLength = value.length;
        int increment = 0;
        for(int i = 0; i < value.length; i++){
          _totalSalesPrice += double.parse(value[i].totalPrice);
          _totalProfitMade += double.parse(value[i].quantity) *
              (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice));

          if(_data.containsKey(value[i].productName)){
            _data[value[i].productName] = [
              _data[value[i].productName][0],
              _data[value[i].productName][1] + double.parse(value[i].quantity),
              _data[value[i].productName][2] + double.parse(value[i].totalPrice),
              _data[value[i].productName][3] + (double.parse(value[i].quantity) *
                  (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice))),
            ];
          }else{
            _data[value[i].productName] = [
              increment,
              double.parse(value[i].quantity),
              double.parse(value[i].totalPrice),
              double.parse(value[i].quantity) *
                  (double.parse(value[i].unitPrice) - double.parse(value[i].costPrice))
            ];
            increment++;
          }
        }
        print(_data);
      });
      getColors();
    }).catchError((onError){
      print(onError.toString());
      _showMessage(onError.toString());
    });
  }

  /// A function to build the the list and send a list of map to build the
  /// data table by calling [_dataTable]
  Widget _buildList() {
    if(_data.length > 0 && _data.isNotEmpty){
      List<Map> _filteredSales = [];
      _data.forEach((k,v) {
        var value = new Map();
        value['sn'] = v[0];
        value['product'] = k;
        value['quantitySold'] = v[1];
        value['totalSales'] = v[2];
        value['profit'] =  v[3];

        _filteredSales.add(value);
      });
      return _dataTable(_filteredSales);
    }
    else{
      Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No sales yet")),
      );
    }
    return Container();
  }

  /// Function to get the amount of colors needed for the pie chart and map
  /// [_data] to [_dataMap]
  void getColors() {
    var toMap = new Map();
    _data.forEach((k,v) {
      if(Constants.sevenUpItems.contains(k)){
        if(toMap.containsKey(k)){
          toMap[k] = toMap[k]+ v[1];
        }else{
          toMap[k] = v[1];
        }
      }
      else {
        if(toMap.containsKey('Others')){
          toMap['Others'] = toMap['Others'] + v[1];
        }else{
          toMap['Others'] = v[1];
        }
      }
    });
    toMap.forEach((k,v) {
      _dataMap.putIfAbsent("$k", () => double.parse('$v'));
    });
    for(int i = 0; i < _dataMap.length; i++){
      _colorList.add(colours[i]);
    }
  }

  /// Convert a double [value] to naira
  FlutterMoneyFormatter _money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  /// Function to build my pie chart if dataMap is not empty and it's length is
  /// > 0 using pie_chart package
  Widget _buildChart(){
    if(_dataMap.length > 0 && _dataMap.isNotEmpty){
      return PieChart(
        dataMap: _dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: false,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: _colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.ring,
      );
    }
    else if(_dataLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No sales yet")),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF008752)),
        ),
      ),
    );
  }

  /// Creating a [DataTable] widget from a List of Map [salesList]
  /// using SN, PRODUCT, QUANTITY SOLD, TOTAL PRICE, PROFIT MADE as DataColumn
  /// and the values of each DataColumn in the [salesList] as DataRows with
  /// a container to show the [_totalSalesPrice] and the [_totalProfitMade]
  SingleChildScrollView _dataTable(List<Map> salesList){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: <Widget>[
          DataTable(
            columnSpacing: 10.0,
            columns: _userType == 'Admin' ? [
              DataColumn(label: Text('SN', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('QTY SOLD', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('TOTAL PRICE', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('PROFIT MADE', style: TextStyle(fontWeight: FontWeight.bold),)),
            ] : [
              DataColumn(label: Text('SN', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('QTY SOLD', style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('TOTAL PRICE', style: TextStyle(fontWeight: FontWeight.bold),)),
            ],
            rows: salesList.map((report) => DataRow(
                cells: _userType == 'Admin' ? [
                  DataCell(Text(report['sn'].toString()),),
                  DataCell(Text(report['product'].toString()),),
                  DataCell(Text(report['quantitySold'].toString()),),
                  DataCell(Text(_money(report['totalSales']).output.symbolOnLeft),),
                  DataCell(Text(_money(report['profit']).output.symbolOnLeft),)
                ] : [
                  DataCell(Text(report['sn'].toString()),),
                  DataCell(Text(report['product'].toString()),),
                  DataCell(Text(report['quantitySold'].toString()),),
                  DataCell(Text(_money(report['totalSales']).output.symbolOnLeft),),
                ]
            )).toList(),
          ),
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 40.0),
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'TOTAL SALES = ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  '${_money(_totalSalesPrice).output.symbolOnLeft}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF008752),
                  ),
                ),
              ],
            ),
          ),
          _userType == 'Admin' ? Container(
            margin: EdgeInsets.only(left: 5.0, right: 40.0),
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'TOTAL PROFITS = ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  '${_money(_totalProfitMade).output.symbolOnLeft}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF008752),
                  ),
                ),
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

  /// It calls [getReports()] and [getCurrentUser()] while initializing my state
  @override
  void initState() {
    super.initState();
    getReports();
    getCurrentUser();
  }

  /// It doesn't show user's [_totalProfitMade] if the [_userType] is not 'Admin'
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Center(child: Text('Products Sold')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          reverse: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildList(),
              SizedBox(height: 15.0,width: 15.0,),
              Center(child: _buildChart()),
            ],
          ),
        ),
      ),
    );
  }

  /// Using flutter toast to display a toast message [message]
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }

}
