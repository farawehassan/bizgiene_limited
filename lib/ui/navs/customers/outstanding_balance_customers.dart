import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/customerDB.dart';
import 'package:bizgienelimited/model/customer_reports_details.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bizgienelimited/model/customer_reports.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// A stateful widget class to display customers with outstanding balance
class OutstandingBalance extends StatefulWidget {

  static const String id = 'outstanding_balance_customers_page';

  @override
  _OutstandingBalanceState createState() => _OutstandingBalanceState();
}

class _OutstandingBalanceState extends State<OutstandingBalance> {

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable of int to hold the numbers of customers
  int _customerLength;

  /// Variable of List<Customer> to hold the details of all the customers
  List<Map<CustomerReport, Customer>> _outstandingCustomers = List();

  /// Function to refresh details of the customers similar to
  /// [_getOutstandingCustomers()]
  Future<Null> _refreshData(){
    List<Map<CustomerReport, Customer>> tempList = List();
    Future<Map<CustomerReport, Customer>> customers = futureValue.getCustomersWithOutstandingBalance();
    return customers.then((value) {
      if(value.length != 0){
        value.forEach((k,v) {
          Map<CustomerReport, Customer> val = Map();
          val[k] = v;
          tempList.add(val);
        });
        if (!mounted) return;
        setState(() {
          _customerLength = tempList.length;
          _outstandingCustomers = tempList;
        });
      } else if(value.length == 0 || value.isEmpty){
        print(value.length);
        if (!mounted) return;
        setState(() {
          _customerLength = 0;
          _outstandingCustomers = [];
        });
      }
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Function to call a number using the [url_launcher] package
  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  /// Converting [dateTime] in string format to return a formatted time
  /// of weekday, month, day and year
  String _getFormattedDate(String dateTime) {
    return DateFormat('MMM d, ''yyyy').format(DateTime.parse(dateTime)).toString();
  }

  /// Function to get all the customers with outstanding balance from the
  /// database and setting the results to [_outstandingCustomers]
  void _getOutstandingCustomers() async {
    List<Map<CustomerReport, Customer>> tempList = List();
    Future<Map<CustomerReport, Customer>> customers = futureValue.getCustomersWithOutstandingBalance();
    await customers.then((value) {
      if(value.length != 0){
        value.forEach((k,v) {
          Map<CustomerReport, Customer> val = Map();
          val[k] = v;
          tempList.add(val);
        });
        if (!mounted) return;
        setState(() {
          _customerLength = tempList.length;
          _outstandingCustomers = tempList;
        });
      } else if(value.length == 0 || value.isEmpty){
        print(value.length);
        if (!mounted) return;
        setState(() {
          _customerLength = 0;
          _outstandingCustomers = [];
        });
      }
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// A function to build the list of the customers with outstanding balance
  Widget _buildList() {
    if(_outstandingCustomers.length > 0 && _outstandingCustomers.isNotEmpty){
      return ListView.builder(
        itemCount: _outstandingCustomers == null ? 0 : _outstandingCustomers.length,
        itemBuilder: (BuildContext context, int index) {
          Customer customer = _outstandingCustomers[index].values.first;
          CustomerReport customerReport = _outstandingCustomers[index].keys.first;
          double balance = double.parse(customerReport.totalAmount) -
              double.parse(customerReport.paymentMade);
          return Container(
            height: 120,
            margin: const EdgeInsets.all(10.0),
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 69.25,
                    padding:
                    const EdgeInsets.only(top: 10.0, left: 12.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.solidFile,
                                ),
                                onPressed: () {
                                  _displayDialog(customerReport);
                                },
                                color: Color(0xFF008752),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green[50]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${customer.name}",
                                    style: GoogleFonts.mcLaren(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      try {
                                        _callPhone("tel:${customer.phone}");
                                      } catch (e) {
                                        print(e);
                                        Constants.showMessage(e);
                                      }
                                    },
                                    child: Text(
                                      "${customer.phone}",
                                      style: GoogleFonts.mcLaren(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton<String>(
                            onSelected: (choice) {
                              choiceAction(choice, customer, customerReport);
                            },
                            itemBuilder: (BuildContext context) {
                              return Constants.showUpdateChoices.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            }
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1.5,
                    color: Colors.grey[500],
                  ),
                  Container(
                    height: 49.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5.0,
                              left: 12.0,
                            ),
                            child: Text(
                              "Balance - ${Constants.money(balance).output.symbolOnLeft}",
                              style: TextStyle(
                                color: Color(0xFF004C7F),
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 49.25,
                          child: Text(''),
                          color: Colors.grey,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5.0,
                              right: 12.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.calendarAlt,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${_getFormattedDate(customerReport.dueDate)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
    else if(_customerLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No customers with outstanding balance yet")),
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

  /// Creating a [DataTable] widget from List<[CustomerReportDetails]> in [CustomerReport]
  /// using QTY, PRODUCT, UNIT, TOTAL as DataColumn and
  /// the values of each DataColumn in the [customerList] as DataRows
  /// Also showing the total amount, payment made and outstanding balance
  SingleChildScrollView _dataTable(CustomerReport customerList){
    double balance = double.parse(customerList.totalAmount) - double.parse(customerList.paymentMade);
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
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 40.0),
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Amount Paid =  ',
                  style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${Constants.money(double.parse(customerList.paymentMade)).output.symbolOnLeft}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF008752),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 40.0),
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Outstanding balance = ',
                  style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${Constants.money(balance).output.symbolOnLeft}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Function to display dialog of customer details [details] by showing
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  padding: EdgeInsets.only(right: 20.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Date Sold = ${_getFormattedDate(details.soldAt)} ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          ' Due Date = ${_getFormattedDate(details.dueDate)}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _dataTable(details),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // To close the dialog
                    },
                    textColor: Color(0xFF008752),
                    child: Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function to display dialog of customer details [details] to be updated
  /// by showing details for inputting
  void _displayUpdateDialog(Customer customer, CustomerReport details){
    /// A [TextEditingController] to control the input text for the amount entered
    TextEditingController amountController = new TextEditingController();
    double balance = double.parse(details.totalAmount) -
        double.parse(details.paymentMade);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    padding: EdgeInsets.only(right: 20.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Date Sold = ${_getFormattedDate(details.soldAt)} ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            ' Due Date = ${_getFormattedDate(details.dueDate)}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 40.0),
                    padding: EdgeInsets.only(right: 20.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Total Amount = ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              '${Constants.money(double.parse(details.totalAmount)).output.symbolOnLeft}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF008752),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Amount Paid =  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              '${Constants.money(double.parse(details.paymentMade)).output.symbolOnLeft}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF008752),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 40.0),
                    padding: EdgeInsets.only(right: 20.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Outstanding balance = ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          '${Constants.money(balance).output.symbolOnLeft}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200.0,
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: kTextFieldDecoration.copyWith(labelText: "Amount Paid"),
                      keyboardType: TextInputType.text,
                      controller: amountController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter the amount paid';
                        }
                        if (double.parse(value) >= balance) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            //Navigator.of(context).pop();
                            if(_formKey.currentState.validate()){
                              _confirmUpdateDialog(customer, details, amountController.text);
                            }
                          },
                          textColor: Color(0xFF008752),
                          child: Text('UPDATE'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // To close the dialog
                          },
                          textColor: Color(0xFF008752),
                          child: Text('CANCEL'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// A function to set actions for the options menu with the value [choice]
  void choiceAction(String choice, Customer customer, CustomerReport customerReport){
    if(choice == Constants.ShowUpdate){
      _displayUpdateDialog(customer, customerReport);
    }
    else if(choice == Constants.ShowSettle){
      _confirmDialog(customer, customerReport);
    }

  }

  /// Calls [_getOutstandingCustomers()] before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _getOutstandingCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      color: Color(0xFF008752),
      child: Container(
        child: _buildList(),
      ),
    );
  }

  /// Function to confirm if a customer's report payment wants to be settled
  void _confirmDialog(Customer customer, CustomerReport customerReport){
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
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Are you sure the customer\'s payment is settled ',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                        _settlePayment(customer, customerReport);
                      },
                      textColor: Color(0xFF008752),
                      child: Text('YES'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      textColor: Color(0xFF008752),
                      child: Text('NO'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function to confirm if a customer's report payment wants to be updated
  void _confirmUpdateDialog(Customer customer, CustomerReport customerReport, String payment){
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
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Confirm ${Constants.money(double.parse(payment)).output.symbolOnLeft} '
                      'to be updated to ${customer.name}\'s payment',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                        Navigator.of(context).pop(); // To close the dialog
                        _updatePayment(customer, customerReport, payment);
                      },
                      textColor: Color(0xFF008752),
                      child: Text('YES'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      textColor: Color(0xFF008752),
                      child: Text('NO'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function that settles a payment of a customer by calling
  /// [settlePaymentReport] in the [RestDataSource] class
  void _settlePayment(Customer customer, CustomerReport customerReport) async {
    var api = new RestDataSource();

    await api.settlePaymentReport(customer.id, customerReport.id, customerReport.totalAmount)
        .then((value) {
           Constants.showMessage('${customer.name} payment settled successfully');
           _refreshData();
        })
        .catchError((onError) {
          print(onError.toString());
          Constants.showMessage(onError.toString());
    });

  }

  /// Function that update a paymentMade of a customer by calling
  /// [updatePaymentMadeReport] in the [RestDataSource] class
  void _updatePayment(Customer customer, CustomerReport customerReport, String payment) async {
    var api = new RestDataSource();

    double newPaymentMade = double.parse(customerReport.paymentMade) + double.parse(payment);

    await api.updatePaymentMadeReport(customer.id, customerReport.id, newPaymentMade.toString())
        .then((value) {
      Constants.showMessage('Updated ${customer.name} payment successfully');
      _refreshData();
    })
    .catchError((onError) {
      print(onError.toString());
      Constants.showMessage(onError.toString());
    });
  }

}
