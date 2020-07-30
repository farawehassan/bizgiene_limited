import 'package:bizgienelimited/model/customerDB.dart';
import 'package:bizgienelimited/model/customer_reports.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';

/// A stateful widget class to display customer details
class CustomerDetails extends StatefulWidget {

  static const String id = 'customer_details_page';

  /// Passing the customer in this class constructor
  final Customer customer;

  /// Passing the list of customer reports in this class constructor
  final List<CustomerReport> customerReports;

  CustomerDetails({@required this.customer, @required this.customerReports});

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {

  /// Variable of int to hold the numbers of reports
  int _reportLength;

  /// Variable of List<CustomerReport> to hold the details of all the
  /// customer's reports
  List<CustomerReport> _reports = List();

  /// Variable of List<String> to hold the soldAt dateTime in string of all the
  /// customer's reports
  List<String> _dates = List();

  /// Variable of Map<String, CustomerReport> to hold the soldAt dateTime in string
  /// to the customer's reports
  Map<String, CustomerReport> _customerReport = Map();

  /// Converting [dateTime] in string format to return a formatted time
  /// of weekday, month, day and year
  String _getFormattedDate(String dateTime) {
    return DateFormat('EEE, MMM d, ''yyyy').format(DateTime.parse(dateTime)).toString();
  }

  /// Creating a [DataTable] widget from List<[CustomerReportDetails]> in [CustomerReport]
  /// using QTY, PRODUCT, UNIT, TOTAL as DataColumn and
  /// the values of each DataColumn in the [customerList] as DataRows
  /// Also showing the total amount
  SingleChildScrollView _dataTable(CustomerReport customerList){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DataTable(
            columnSpacing: 10.0,
            columns: [
              DataColumn(label: Text('QTY', style: TextStyle(fontWeight: FontWeight.normal),)),
              DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.normal),)),
              DataColumn(label: Text('UNIT', style: TextStyle(fontWeight: FontWeight.normal),)),
              DataColumn(label: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.normal),)),
            ],
            rows: customerList.reportDetails.map((customer) {
              return DataRow(
                  cells: [
                    DataCell(
                      Text(customer.quantity.toString()),
                    ),
                    DataCell(
                      Text(customer.productName.toString()),
                    ),
                    DataCell(
                      Text(Constants.money(double.parse(customer.unitPrice)).output.symbolOnLeft.toString()),
                    ),
                    DataCell(
                      Text(Constants.money(double.parse(customer.totalPrice)).output.symbolOnLeft.toString()),
                    ),
                  ]
              );
            }).toList(),
          ),
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 40.0),
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Total Amount = ',
                  style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${Constants.money(double.parse(customerList.totalAmount)).output.symbolOnLeft}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF008752),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Function to display dialog of customer report's details [details] by showing
  /// [_dataTable()]
  void _displayDialog(CustomerReport details){
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _dataTable(details),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  textColor: Color(0xFF008752),
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function to get all the report dates from a customer's list of reports
  /// to [_dates]
  void _getAllReportDates() {
    _reports = widget.customerReports.reversed.toList();
    _reportLength = _reports.length;
    for(var report in _reports){
      _dates.add(_getFormattedDate(report.soldAt));
      _customerReport[_getFormattedDate(report.soldAt)] = report;
    }
  }

  /// A function to build the list of all the customer's reports
  Widget _buildList() {
    if(_dates.length > 0 && _dates.isNotEmpty){
      return ListView.builder(
        itemCount: _dates == null ? 0 : _dates.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _displayDialog(_customerReport[_dates[index]]);
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.expand_more, color: Color(0xFF008752)),
                      onPressed: () {
                        _displayDialog(_customerReport[_dates[index]]);
                      },
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      _dates[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    else if(_reportLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No reports yet")),
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

  /// Calling [_getAllReportDates() before the class build its widgets]
  @override
  void initState() {
    super.initState();
    _getAllReportDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Text('${widget.customer.name}'),
      ),
      body: SafeArea(
        child: Container(
          child: _buildList(),
        ),
      ),
    );
  }

}
