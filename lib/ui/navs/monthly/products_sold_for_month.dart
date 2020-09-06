import 'package:flutter/material.dart';
import 'package:bizgienelimited/bloc/daily_report_value.dart';
import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/reportsDB.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class MonthlyProductSold extends StatefulWidget {

  static const String id = 'products_sold_for_the_month';

  final List<Reports> reports;

  const MonthlyProductSold({Key key, this.reports}) : super(key: key);

  @override
  _MonthlyProductSoldState createState() => _MonthlyProductSoldState();
}

class _MonthlyProductSoldState extends State<MonthlyProductSold> {

  /// Instantiating a class of the [DailyReportValue]
  var reportValue = DailyReportValue();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A variable holding my report data as a map
  var _data = new Map();

  /// Variable to hold the type of the user logged in
  String _userType;

  /// Setting the current user's type logged in to [userType]
  void _getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      _userType = user.type;
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  /// Function to get this [month] report and map [_data] it's product name to
  /// its quantity accordingly
  /// It also calls the function [getColors()]
  void _getReports() async {
    if (!mounted) return;
    setState(() {
      int increment = 0;
      for(int i = 0; i < widget.reports.length; i++){
        if(_data.containsKey(widget.reports[i].productName)){
          _data[widget.reports[i].productName] = [
            _data[widget.reports[i].productName][0],
            _data[widget.reports[i].productName][1] + double.parse(widget.reports[i].quantity),
            _data[widget.reports[i].productName][2] + double.parse(widget.reports[i].totalPrice),
            _data[widget.reports[i].productName][3] + (double.parse(widget.reports[i].quantity) *
                (double.parse(widget.reports[i].unitPrice) - double.parse(widget.reports[i].costPrice))),
          ];
        }else{
          _data[widget.reports[i].productName] = [
            increment,
            double.parse(widget.reports[i].quantity),
            double.parse(widget.reports[i].totalPrice),
            double.parse(widget.reports[i].quantity) *
                (double.parse(widget.reports[i].unitPrice) - double.parse(widget.reports[i].costPrice))
          ];
          increment++;
        }
      }
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
    else if(_data.length == 0 || _data.isEmpty || _data == null){
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
      child: DataTable(
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
              DataCell(Text(Constants.money(report['totalSales']).output.symbolOnLeft),),
              DataCell(Text(Constants.money(report['profit']).output.symbolOnLeft),)
            ] : [
              DataCell(Text(report['sn'].toString()),),
              DataCell(Text(report['product'].toString()),),
              DataCell(Text(report['quantitySold'].toString()),),
              DataCell(Text(Constants.money(report['totalSales']).output.symbolOnLeft),),
            ]
        )).toList(),
      ),
    );
  }

  /// It calls [getReports()], [getCurrentUser()] and [_getOutstandingPayment()]
  /// while initializing my state
  @override
  void initState() {
    super.initState();
    _getReports();
    _getCurrentUser();
  }

  /// It doesn't show user's [_totalProfitMade] if the [_userType] is not 'Admin'
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Text('Products Sold'),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            reverse: false,
            child:  _buildList(),
          ),
        ),
      ),
    );
  }

}
