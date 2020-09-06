import 'package:bizgienelimited/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DTS extends DataTableSource{

  DTS({@required this.salesList});

  final List<Map> salesList;

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(String dateTime) {
    return DateFormat('EEE, MMM d, h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(
        Text(salesList[index]['qty'].toString()),
      ),
      DataCell(
        Text(salesList[index]['productName'].toString()),
      ),
      DataCell(
        Text(Constants.money(double.parse(salesList[index]['unitPrice'])).output.symbolOnLeft),
      ),
      DataCell(
        Text(Constants.money(double.parse(salesList[index]['totalPrice'])).output.symbolOnLeft),
      ),
      DataCell(
        Text(salesList[index]['paymentMode'].toString()),
      ),
      DataCell(
        Text(_getFormattedTime(salesList[index]['time'])),
      ),
      DataCell(
        Text(salesList[index]['customerName'].toString()),
      ),
    ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => salesList.length;

  @override
  int get selectedRowCount => 0;

}
