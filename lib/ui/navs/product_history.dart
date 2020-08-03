import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/product_history_details.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';

/// A StatefulWidget class that displays a product history from the database
class ProductHistoryPage extends StatefulWidget {

  static const String id = 'product_history';

  /// Passing the products recorded in this class constructor
  final String productHistoryId;

  ProductHistoryPage({@required this.productHistoryId});

  @override
  _ProductHistoryPageState createState() => _ProductHistoryPageState();
}

class _ProductHistoryPageState extends State<ProductHistoryPage> {

  /// Instantiating a class of the [FutureValues]
  final futureValue = FutureValues();

  /// A Map to hold the history's data
  Map _data = {};

  /// A List to hold the Map of the history's data above
  List<Map> _history = [];

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(String dateTime) {
    return DateFormat('yMMMMd').format(DateTime.parse(dateTime)).toString();
  }

  /// Creating a [DataTable] widget from a List of Map [productHistoryList]
  /// using PRODUCT, INITIAL QTY, QTY RECEIVED, CURRENT QTY as DataColumn and
  /// the values of each DataColumn in the [productHistoryList] as DataRows
  SingleChildScrollView _dataTable(List<Map> productHistoryList){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10.0,
        columns: [
          DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('INITIAL QTY', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('QTY RECEIVED', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('CURRENT QTY', style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text('TIME', style: TextStyle(fontWeight: FontWeight.bold),)),
        ],
        rows: productHistoryList.map((history) => DataRow(
            cells: [
              DataCell(
                Text(history['productName'].toString()),
              ),
              DataCell(
                Text(history['initialQty'].toString()),
              ),
              DataCell(
                Text(history['qtyReceived'].toString()),
              ),
              DataCell(
                Text(history['currentQty'].toString()),
              ),
              DataCell(
                Text(_getFormattedTime(history['time'])),
              ),
            ]
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _data.clear();
    _history.clear();
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Center(child: Text('History')),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          reverse: true,
          child: Align(
            alignment: Alignment.topCenter,
            child: FutureBuilder(
              future: futureValue.getAProductHistoryFromDB(widget.productHistoryId),
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
                  List<ProductHistoryDetails> historyDetails = snapshot.data.historyDetails;
                  for (int i = 0; i < historyDetails.length; i++){
                    _data = {'productName':'${snapshot.data.productName}', 'initialQty':'${historyDetails[i].initialQty}', 'qtyReceived': '${historyDetails[i].qtyReceived}','currentQty':'${historyDetails[i].currentQty}','time':'${historyDetails[i].collectedAt}'};
                    _history.add(_data);
                  }
                  return _dataTable(_history);
                }
                else {
                  Container(
                      alignment: AlignmentDirectional.center,
                      child: Text("No history yet")
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
      ),
    );
  }
}
