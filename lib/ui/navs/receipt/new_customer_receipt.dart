import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/customerDB.dart';
import 'package:bizgienelimited/model/customer_reports.dart';
import 'package:bizgienelimited/model/customer_reports_details.dart';
import 'package:bizgienelimited/model/reportsDB.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/styles/theme.dart' as Theme;
import 'package:bizgienelimited/ui/navs/home_page.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/reusable_card.dart';
import 'package:bizgienelimited/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class NewCustomerReceipt extends StatefulWidget {

  static const String id = 'new_customer_receipt_page';

  /// Passing the products recorded in this class constructor
  final List<Map> sentProducts;

  NewCustomerReceipt({@required this.sentProducts});

  @override
  _NewCustomerReceiptState createState() => _NewCustomerReceiptState();
}

class _NewCustomerReceiptState extends State<NewCustomerReceipt> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the customer name
  TextEditingController _nameController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the customer phone
  TextEditingController _phoneController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the total amount
  TextEditingController _totalAmountController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the amount paid
  TextEditingController _amountPaidController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the outstanding balance
  TextEditingController _outstandingBalanceController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the due date
  TextEditingController _dueDateController = new TextEditingController();

  /// Constant holding the company's name
  static const String _companyName = "BizGenie Limited";

  /// Constant holding the company's name
  static const String _companyDetails = "General Distributors / Contractors Suppliers";

  /// Constant holding the company's address
  static const String _address = "56, Olumegbon Rd Gbaja, Surulere, Lagos";

  /// Constant holding the company's phone number
  static const String _phoneNumber = "08025013518, 09072222068";

  /// Constant holding the company's email
  static const String _email = "mbkosoko@yahoo.com";

  /// Variable holding today's datetime
  DateTime _dateTime = DateTime.now();

  /// Variable holding the due date and time
  DateTime _dueDate;

  /// Variable holding the customer's name
  String _customerName;

  /// Variable holding the customer's name
  String _customerPhone;

  /// Variable holding the total price
  double _totalPrice = 0.0;

  /// Variable holding the amount paid
  double _amountPaid = 0.0;

  /// Variable holding the outstanding balance
  double _outstandingBalance = 0.0;

  /// Boolean variable holding true or false if the payment is fully paid
  bool _fullyPaid = false;

  /// A List to hold the widget [TableRow] for my products
  List<TableRow> items = [];

  /// A List to hold the Map of [receivedProducts]
  List<Map> receivedProducts = [];

  /// A Map to hold the names of all the customers in the database
  Map _customerDetails = Map();

  /// A List to hold the names of all the customers in the database
  List<String> _customerNames = List();

  /// Instantiating a class of the [Reports]
  Reports dailyReportsData = new Reports();

  /// A constant for border radius size in my [_paymentDetailsTable()]
  static const double _borderSize = 15.0;

  /// A constant for padding size in my [_paymentDetailsTable()]
  static const double _paddingSize = 12.0;

  /// A double variable for the animated height in [_paymentDetails()]
  double _animatedHeight = 340.0;

  /// Boolean variables for selection in [_whenToPay()]
  bool _received = false;
  bool _later = true;

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(String dateTime) {
    return DateFormat('h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  /// Converting [dateTime] in string format to return a formatted time
  /// of weekday, month, day and year
  String _getFormattedDate(String dateTime) {
    return DateFormat('MMM d, ''yyyy').format(DateTime.parse(dateTime)).toString();
  }

  /// This adds the product details [sentProducts] to [receivedProducts] if it's
  /// not empty and calculate the total price [totalPrice]
  void _addProducts() {
    for (var product in widget.sentProducts) {
      if (product.isNotEmpty
          && product.containsKey('qty')
          && product.containsKey('product')
          && product.containsKey('costPrice')
          && product.containsKey('unitPrice')
          && product.containsKey('totalPrice')
      )  {
        receivedProducts.add(product);
        _totalPrice += double.parse(product['totalPrice']);
      }
    }
  }

  /// This function contains the details of the store such as [_companyName],
  /// [_customerDetails], [_address], [_phoneNumber], [_email]
  Container _storeDetails() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
                _companyName,
                style: GoogleFonts.mcLaren(
                  fontSize: 26.0,
                  color: Color(0xFF008752),
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          Container(
            child: Text(
              _companyDetails,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.0),
            child: Text(
              _address,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Container(
            child: Text(
              "Tel: $_phoneNumber",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Container(
            child: Text(
              "Email: $_email",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creating a [DataTable] widget from a List of Map [receivedProducts]
  /// using QTY, PRODUCT, UNIT, TOTAL, PAYMENT, TIME as DataColumn and
  /// the values of each DataColumn in the [receivedProducts] as DataRows
  Widget _dataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 5.0,
        columns: [
          DataColumn(
            label: Text(
              'S/N',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
              label: Text(
                'QTY',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          DataColumn(
              label: Text(
                'PRODUCT',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          DataColumn(
              label: Text(
                'UNIT PRICE',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          DataColumn(
              label: Text(
                'TOTAL PRICE',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
        rows: receivedProducts.map((product) {
          return DataRow(cells: [
            DataCell(
              Text((widget.sentProducts.indexOf(product) + 1).toString()),
            ),
            DataCell(
              Text(product['qty'].toString()),
            ),
            DataCell(
              Text(product['product'].toString()),
            ),
            DataCell(
              Text(Constants.money(double.parse(product['unitPrice'])).output.symbolOnLeft.toString()),
            ),
            DataCell(
              Text(Constants.money(double.parse(product['totalPrice'])).output.symbolOnLeft.toString()),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  /// A widget to return a container of payment details and other information
  /// regarding to the customer
  AnimatedContainer _paymentDetailsTable() {
    _totalAmountController.text = Constants.money(_totalPrice).output
        .symbolOnLeft.toString();
    return AnimatedContainer(
      margin: EdgeInsets.all(_paddingSize),
      height: _animatedHeight,
      duration: Duration(seconds: 0),
      width: SizeConfig.safeBlockHorizontal * 80,
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(_borderSize),
        child:  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderSize),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        Color(0xFF004C7F),
                        Color(0xFF008752),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_borderSize),
                      topRight: Radius.circular(_borderSize),
                    ),
                  ),
                  padding: EdgeInsets.all(_paddingSize),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Date: ${_getFormattedDate(_dateTime.toString())}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Time: ${_getFormattedTime(_dateTime.toString())}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(_paddingSize),
                            child: Text(
                              'Customer Name',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(right: _paddingSize),
                              width: 250.0,
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty || _customerNames
                                      .contains(Constants.capitalize(value))) {
                                    setState(() {
                                      if(_animatedHeight == 340){
                                        _animatedHeight = 371;
                                      }
                                      else if(_animatedHeight == 371){
                                        _animatedHeight = 395;
                                      }
                                      else if(_animatedHeight == 395){
                                        _animatedHeight = 419;
                                      }
                                    });
                                    return 'Enter a valid name';
                                  }
                                  setState(() {
                                    if(_animatedHeight == 371){
                                      _animatedHeight = 371;
                                    }
                                    else if(_animatedHeight == 395){
                                      _animatedHeight = 395;
                                    }else if(_animatedHeight == 419){
                                      _animatedHeight = 419;
                                    } else {
                                      _animatedHeight = 340;
                                    }
                                  });
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                                onChanged: (value){
                                  if (!mounted) return;
                                  setState(() {
                                    _customerName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Customer Name",
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(_paddingSize),
                            child: Text(
                              'Phone Number',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(right: _paddingSize),
                              width: 150.0,
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                controller: _phoneController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      if(_animatedHeight == 340){
                                        _animatedHeight = 371;
                                      }
                                      else if(_animatedHeight == 371){
                                        _animatedHeight = 395;
                                      }
                                      else if(_animatedHeight == 395){
                                        _animatedHeight = 419;
                                      }
                                    });
                                    return 'Enter number';
                                  }
                                  setState(() {
                                    if(_animatedHeight == 371){
                                      _animatedHeight = 371;
                                    }
                                    else if(_animatedHeight == 395){
                                      _animatedHeight = 395;
                                    }else if(_animatedHeight == 419){
                                      _animatedHeight = 419;
                                    } else {
                                      _animatedHeight = 340;
                                    }
                                  });
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                                onChanged: (value){
                                  if (!mounted) return;
                                  setState(() {
                                    _customerPhone = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "0701...",
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(_paddingSize),
                            child: Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(right: _paddingSize),
                              width: 150.0,
                              child: TextFormField(
                                enabled: false,
                                controller: _totalAmountController,
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(_paddingSize),
                            child: Text(
                              'Amount Paid',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(right: _paddingSize),
                              width: 150.0,
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                controller: _amountPaidController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      if(_animatedHeight == 340){
                                        _animatedHeight = 371;
                                      }
                                      else if(_animatedHeight == 371){
                                        _animatedHeight = 395;
                                      }
                                      else if(_animatedHeight == 395){
                                        _animatedHeight = 419;
                                      }
                                    });
                                    return 'Enter the amount paid';
                                  }
                                  setState(() {
                                    if(_animatedHeight == 371){
                                      _animatedHeight = 371;
                                    }
                                    else if(_animatedHeight == 395){
                                      _animatedHeight = 395;
                                    }else if(_animatedHeight == 419){
                                      _animatedHeight = 419;
                                    } else {
                                      _animatedHeight = 340;
                                    }
                                  });
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                                onChanged: (value){
                                  if (!mounted) return;
                                  setState(() {
                                    _amountPaid = double.parse(value);
                                    _outstandingBalance = _totalPrice - _amountPaid;
                                    _outstandingBalanceController.text =
                                        Constants.money(_outstandingBalance)
                                            .output.symbolOnLeft.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "N0.00",
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(_paddingSize),
                            child: Text(
                              'Outstanding Balance',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(right: _paddingSize),
                              width: 150.0,
                              child: TextFormField(
                                enabled: false,
                                controller: _outstandingBalanceController,
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Outstanding balance';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "N0.00",
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
                _later
                    ?  Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(_paddingSize),
                        child: Text(
                          'Due Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.only(right: _paddingSize),
                          width: 150.0,
                          child: GestureDetector(
                            onDoubleTap: (){
                              Platform.isIOS ?
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 0.0,
                                  child: Container(
                                    height: 350.0,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: SizedBox(
                                            height: 200.0,
                                            child: CupertinoDatePicker(
                                              initialDateTime: _dateTime,
                                              onDateTimeChanged: (DateTime value) {
                                                if (!mounted) return;
                                                setState(() {
                                                  _dueDate = value;
                                                  _dueDateController.text =
                                                      _getFormattedDate(_dueDate.toString());
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24.0,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // To close the dialog
                                            },
                                            textColor: Color(0xFF008752),
                                            child: Text('CONFIRM'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ) : showDatePicker(
                                  context: context,
                                  initialDate: _dateTime,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030)
                              ).then((value) {
                                if (!mounted) return;
                                setState(() {
                                  if(value != null){
                                    _dueDate = value;
                                    _dueDateController.text =
                                        _getFormattedDate(_dueDate.toString());
                                  }
                                });
                              });
                            },
                            child: Text(
                              _dueDate != null
                                  ? '${_getFormattedDate(_dueDate.toString())}'
                                  : '???',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    :  Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(_paddingSize),
                        child: Text(
                          'Payment Received',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.only(right: _paddingSize),
                          width: 150.0,
                          child: GestureDetector(
                            onDoubleTap: (){
                              Platform.isIOS ?
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 0.0,
                                  child: Container(
                                    height: 350.0,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: SizedBox(
                                            height: 200.0,
                                            child: CupertinoDatePicker(
                                              initialDateTime: _dateTime,
                                              onDateTimeChanged: (DateTime value) {
                                                if (!mounted) return;
                                                setState(() {
                                                  _dueDate = value;
                                                  _dueDateController.text =
                                                      _getFormattedDate(_dueDate.toString());
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24.0,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // To close the dialog
                                            },
                                            textColor: Color(0xFF008752),
                                            child: Text('CONFIRM'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ) : showDatePicker(
                                  context: context,
                                  initialDate: _dateTime,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030)
                              ).then((value) {
                                if (!mounted) return;
                                setState(() {
                                  if(value != null){
                                    _dueDate = value;
                                    _dueDateController.text =
                                        _getFormattedDate(_dueDate.toString());
                                  }
                                });
                              });
                            },
                            child: Text(
                              _dueDate != null
                                  ? '${_getFormattedDate(_dueDate.toString())}'
                                  : '???',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A widget that displays a container to select payment type if it is already
  /// received or will be received later
  Container _whenToPay(){
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'Payment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                SelectCard(
                  text1: "Payment",
                  text2: "Received",
                  onPress: (){
                    if(!mounted) return;
                    setState(() {
                      _received = true;
                      _later = false;
                      _amountPaidController.text = _totalPrice.toString();
                      _outstandingBalanceController.text = '0.00';
                      _outstandingBalance = 0.00;
                      _amountPaid = _totalPrice;
                      _fullyPaid = true;
                    });
                  },
                  isSelected: _later ? false : true,
                ),
                SizedBox(width: 20.0,),
                SelectCard(
                  text1: "Accept",
                  text2: "payment later",
                  onPress: (){
                    if(!mounted) return;
                    setState(() {
                      _later = true;
                      _received = false;
                      _amountPaidController.clear();
                      _outstandingBalanceController.clear();
                      _amountPaid = 0.00;
                      _fullyPaid = true;
                    });
                  },
                  isSelected: _received ? false : true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Function to fetch all the available product's names and details from the
  /// database to [_customerNames] and [_customerDetails]
  void _allCustomerNames() {
    Future<Map<String, String>> customerNames = futureValue.getAllCustomerNamesFromDB();
    customerNames.then((value) {
      _customerDetails.addAll(value);
      _customerNames.addAll(value.keys);
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Calls [_addProducts()] and [_allCustomerNames()] before the class
  /// builds its widgets
  @override
  void initState() {
    super.initState();
    _addProducts();
    _allCustomerNames();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Text('Receipt for a new customer'),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrintingReceipt(sentProducts: receivedProducts)),
              );
            },
          ),*/
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                _storeDetails(),
                SizedBox(
                  height: 2.0,
                ),
                _paymentDetailsTable(),
                _whenToPay(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[_dataTable()],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: new LinearGradient(
                          colors: [
                            Theme.ColorGradients.loginGradientStart,
                            Theme.ColorGradients.loginGradientEnd
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Theme.ColorGradients.loginGradientEnd,
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 80,
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 21.0),
                          child: Text(
                            'CONFIRM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0
                            ),
                          ),
                        ),
                      onPressed: () {
                        if(_dueDate == null){
                          Constants.showMessage("Double tap to select date");
                        }
                        if(_formKey.currentState.validate() && _dueDate != null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                elevation: 0.0,
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 60,
                                  height: 150.0,
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 16.0),
                                          child: Text(
                                            "Are you sure the product you want to save is confirmed?",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // To close the dialog
                                              },
                                              textColor: Color(0xFF008752),
                                              child: Text('NO'),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // To close the dialog
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (_) => Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(16.0),
                                                    ),
                                                    elevation: 0.0,
                                                    child: Container(
                                                      width: SizeConfig.safeBlockHorizontal * 60,
                                                      height: 150.0,
                                                      padding: EdgeInsets.all(16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(
                                                                  top: 16.0),
                                                              child: Text(
                                                                "Select payment mode",
                                                                style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.end,
                                                            children: <Widget>[
                                                              Align(
                                                                alignment:
                                                                Alignment.bottomLeft,
                                                                child: FlatButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context)
                                                                        .pop(); // To close the dialog
                                                                    _saveProduct('Transfer');
                                                                  },
                                                                  textColor: Color(0xFF008752),
                                                                  child: Text('Transfer'),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                Alignment.bottomRight,
                                                                child: FlatButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context)
                                                                        .pop(); // To close the dialog
                                                                    _saveProduct('Cash');
                                                                  },
                                                                  textColor: Color(0xFF008752),
                                                                  child: Text('Cash'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              textColor: Color(0xFF008752),
                                              child: Text('YES'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// This function calls [_saveNewCustomerReports()] to save the new customer
  /// with its reports then [saveNewDailyReport()] with the details in [receivedProducts]
  /// to save the reports into reports table
  void _saveProduct(String paymentMode) async {
    if(receivedProducts.length > 0 && receivedProducts.isNotEmpty){
      try {
        await _saveNewCustomerReports().then((value) async {
          Constants.showMessage('$_customerName items were successfully added');
          for (var product in receivedProducts) {
            await _saveNewDailyReport(
                double.parse(product['qty']),
                product['product'],
                double.parse(product['costPrice']),
                double.parse(product['unitPrice']),
                double.parse(product['totalPrice']),
                paymentMode
            ).then((value){
              print("${product['product']} was sold successfully");
            });
          }
        }).catchError((e) {
          print(e);
          Constants.showMessage('${e.toString()}');
        });
      } catch (e) {
        print(e);
        Constants.showMessage('${e.toString()}');
      }
      Navigator.popUntil(context, ModalRoute.withName(MyHomePage.id));
    }
    else {
      Constants.showMessage("Empty receipt");
      Navigator.pop(context);
    }
  }

  /// This function saves new customer with the details collected
  /// above into [CustomerReport] object such as :
  ///   reports from [_customerReportList()],
  ///   totalAmount from [_totalPrice],
  ///   paymentMade from [_amountPaid],
  ///   paid from [_fullyPaid],
  ///   soldAt from [_dateTime],
  ///   dueDate from [_dueDate]
  Future<void> _saveNewCustomerReports() async {
    var api = RestDataSource();

    var customer = Customer();
    customer.name = Constants.capitalize(_customerName);
    customer.phone = _customerPhone;
    customer.createdAt = _dateTime.toString();

    var customerReport = CustomerReport();
    customerReport.reportDetails = _customerReportList();
    customerReport.totalAmount = _totalPrice.toString();
    customerReport.paymentMade = _amountPaid.toString();
    customerReport.paid = _fullyPaid;
    customerReport.soldAt = _dateTime.toString();
    customerReport.dueDate = _dueDate.toString();

    /*fullyPaid
        ? customerReport.paymentReceivedAt = _dateTime.toString()
        : customerReport.dueDate = _dueDate.toString();*/

    await api.addCustomer(customer, customerReport).then((value) {
      print('$_customerName items was successfully added');
    }).catchError((e) {
      print(e);
      throw (e);
    });

  }

  /// This function sets all the products in [receivedProducts] into and List
  /// of [CustomerReportDetails]
  List<CustomerReportDetails> _customerReportList() {
    List<CustomerReportDetails> reports = new List();
    for (var product in receivedProducts) {
      var customerReportDetails = CustomerReportDetails();
      customerReportDetails.quantity = product['qty'].toString();
      customerReportDetails.productName = product['product'].toString();
      customerReportDetails.costPrice = product['costPrice'].toString();
      customerReportDetails.unitPrice = product['unitPrice'].toString();
      customerReportDetails.totalPrice = product['totalPrice'].toString();

      reports.add(customerReportDetails);
    }
    return reports;
  }

  /// Function that adds new report to the database by calling
  /// [addNewDailyReport] in the [RestDataSource] class
  Future<void> _saveNewDailyReport(double qty, String productName, double costPrice, double unitPrice,
      double total, String paymentMode) async {
    try {
      var api = RestDataSource();
      var dailyReport = Reports();
      dailyReport.quantity = qty.toString();
      dailyReport.productName = productName.toString();
      dailyReport.costPrice = costPrice.toString();
      dailyReport.unitPrice = unitPrice.toString();
      dailyReport.totalPrice = total.toString();
      dailyReport.paymentMode = paymentMode;
      dailyReport.createdAt = DateTime.now().toString();

      await api.addNewDailyReport(dailyReport).then((value) {
        print('$productName saved successfully');
      }).catchError((e) {
        print(e);
        throw (e);
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

}
