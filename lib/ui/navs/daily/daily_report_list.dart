import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';

/// A StatelessWidget class that displays detailed list of items sold today
// ignore: must_be_immutable
class DailyReportList extends StatelessWidget {

  static const String id = 'daily_report_list';

  /// Instantiating a class of the [FutureValues]
  final futureValue = FutureValues();

  /// A Map to hold the report's data
  Map _data = {};

  /// A List to hold the Map of the report's data above
  List<Map> _reports = [];

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(String dateTime) {
    return DateFormat('h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  /// Creating a [DataTable] widget from a List of Map [salesList]
  /// using QTY, PRODUCT, UNIT, TOTAL, PAYMENT, TIME as DataColumn and
  /// the values of each DataColumn in the [salesList] as DataRows
  SingleChildScrollView _dataTable(List<Map> salesList){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10.0,
        columns: [
          DataColumn(label: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('UNIT', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('PAYMENT', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('TIME', style: TextStyle(fontWeight: FontWeight.bold),)),
        ],
        rows: salesList.map((report) => DataRow(
            cells: [
              DataCell(
                Text(report['qty'].toString()),
              ),
              DataCell(
                Text(report['productName'].toString()),
              ),
              DataCell(
                Text(Constants.money(double.parse(report['unitPrice'])).output.symbolOnLeft.toString()),
              ),
              DataCell(
                Text(Constants.money(double.parse(report['totalPrice'])).output.symbolOnLeft.toString()),
              ),
              DataCell(
                Text(report['paymentMode'].toString()),
              ),
              DataCell(
                Text(_getFormattedTime(report['time'])),
              ),
            ]
        )).toList(),
      ),
    );
  }

  /// Building a Scaffold Widget to display a detailed list of today's report
  /// in [_dataTable()] format
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, d MMM').format(now);
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Today\'s Sales'),
            Text(formattedDate),
          ],
        ),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: FutureBuilder(
                  future: futureValue.getTodayReports(),
                  builder: (context, snapshot){
                    if (snapshot.hasError) {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      );
                    }
                    if(snapshot.hasData){
                      for (int i = 0; i < snapshot.data.length; i++){
                        _data = {'qty':'${snapshot.data[i].quantity}', 'productName': '${snapshot.data[i].productName}','unitPrice':'${snapshot.data[i].unitPrice}','totalPrice':'${snapshot.data[i].totalPrice}', 'paymentMode':'${snapshot.data[i].paymentMode}', 'time':'${snapshot.data[i].createdAt}'};
                        _reports.add(_data);
                      }
                      return _dataTable(_reports);
                    }
                    else {
                      Container(
                        alignment: AlignmentDirectional.center,
                        child: Text("No sales yet")
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
                  },
                ),
              ),
            ],
          )
      ),
    );
  }

}
