import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/customerDB.dart';
import 'package:bizgienelimited/model/customer_reports.dart';
import 'package:bizgienelimited/model/customer_reports_details.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/ui/navs/customers/customer_details.dart';
import 'package:bizgienelimited/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// A stateful widget class to display all your customers
class AllCustomers extends StatefulWidget {

  static const String id = 'all_customer_page';

  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  /// A [TextEditingController] to control the input text for the user's password
  TextEditingController _deletePasswordController = new TextEditingController();

  /// GlobalKey of a my form state to validate my form while deleting a customer
  final _confirmDeleteFormKey = new GlobalKey<FormState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable of int to hold the numbers of customers
  int _customerLength;

  /// Variable of List<Customer> to hold the details of all the customers
  List<Map<Customer, List<CustomerReport>>> _allCustomers = List();

  /// Function to refresh details of the customers similar to
  /// [_getAllCustomers()]
  Future<Null> _refreshData(){
    List<Map<Customer, List<CustomerReport>>> tempList = List();
    Future<Map<Customer, List<CustomerReport>>> customers = futureValue.getAllCustomersSorted();
    return customers.then((value) {
      if(value.length != 0){
        value.forEach((k,v) {
          Map<Customer, List<CustomerReport>> val = Map();
          val[k] = v;
          tempList.add(val);
        });
        if (!mounted) return;
        setState(() {
          _customerLength = tempList.length;
          _allCustomers = tempList;
        });
      } else if(value.length == 0 || value.isEmpty){
        if (!mounted) return;
        setState(() {
          _customerLength = 0;
          _allCustomers = [];
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

  /// Function to get all the customers from the database and setting the results
  /// to [_allCustomers]
  void _getAllCustomers() async {
    List<Map<Customer, List<CustomerReport>>> tempList = List();
    Future<Map<Customer, List<CustomerReport>>> customers = futureValue.getAllCustomersSorted();
    await customers.then((value) {
      if(value.length != 0){
        value.forEach((k,v) {
          Map<Customer, List<CustomerReport>> val = Map();
          val[k] = v;
          tempList.add(val);
        });
        if (!mounted) return;
        setState(() {
          _customerLength = tempList.length;
          _allCustomers = tempList;
        });
      } else if(value.length == 0 || value.isEmpty){
        if (!mounted) return;
        setState(() {
          _customerLength = 0;
          _allCustomers = [];
        });
      }
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// A function to build the list of all your customers
  Widget _buildList() {
    if(_allCustomers.length > 0 && _allCustomers.isNotEmpty){
      return ListView.builder(
        itemCount: _allCustomers == null ? 0 : _allCustomers.length,
        itemBuilder: (BuildContext context, int index) {
          Customer customer= _allCustomers[index].keys.first;
          List<CustomerReport> customerReport = _allCustomers[index].values.first;
          double lastTotalAmount = double.parse(customerReport.last.totalAmount);
          return GestureDetector(
            onLongPress: (){
              _confirmDeleteDialog(customer);
            },
            child: Container(
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CustomerDetails(
                                        customer: customer,
                                        customerReports: customerReport,
                                      )),
                                    );
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
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.mcLaren(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if(customer.phone.isNotEmpty || (customer.phone != "")){
                                          try {
                                            _callPhone("tel:${customer.phone}");
                                          } catch (e) {
                                            print(e);
                                            Constants.showMessage(e);
                                          }
                                        }
                                      },
                                      child: Text(
                                        "${customer.phone}",
                                        overflow: TextOverflow.ellipsis,
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
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CustomerDetails(
                                  customer: customer,
                                  customerReports: customerReport,
                                )),
                              );
                            },
                            child: Icon(
                              Icons.more_vert,
                            ),
                          )
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
                                "Last - ${Constants.money(lastTotalAmount).output.symbolOnLeft}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF004C7F),
                                  fontWeight: FontWeight.normal,
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                                      "${_getFormattedDate(customerReport.last.soldAt)}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4,
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
            ),
          );
        },
      );
    }
    else if(_customerLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No customers yet")),
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

  /// Calls [_getAllCustomers()] before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _getAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      color: Color(0xFF008752),
      child: Container(
        child: _buildList(),
      ),
    );
  }

  /// Function to confirm if a customer sales wants to be deleted
  /// It calls [_deleteCustomerReport()] if user confirms
  void _confirmDeleteDialog(Customer customer){
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Container(
          //height: 320.0,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Are you sure you want to delete this customer',
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
                        _confirmPasswordDeleteDialog(customer);
                      },
                      textColor: Colors.red,
                      child: Text('YES'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // To close the dialog
                      },
                      textColor: Colors.red,
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

  /// Function to confirm if a customer sales wants to be deleted by entering pin
  /// It calls [_deleteCustomerReport()] if user confirms
  void _confirmPasswordDeleteDialog(Customer customer){
    bool obscureTextLogin = true;
    _deletePasswordController.clear();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Form(
          key: _confirmDeleteFormKey,
          child: Container(
            height: 200.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enter your pin',
                    style: TextStyle(
                      color: Color(0xFF008752),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Container(
                  width: 150.0,
                  child: TextFormField(
                    controller: _deletePasswordController,
                    obscureText: obscureTextLogin,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a pin';
                      }
                      if (int.parse(_deletePasswordController.text) != 1234) {
                        return 'Incorrect pin';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      decoration: TextDecoration.underline
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.lock,
                        size: 22.0,
                        color: Colors.black,
                      ),
                      hintText: "Pin",
                      hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black54
                      ),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          if(!mounted)return;
                          setState(() {
                            obscureTextLogin = !obscureTextLogin;
                          });
                        },
                        child: Icon(
                          obscureTextLogin
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deletePasswordController.clear();// To close the dialog
                        },
                        textColor: Colors.red,
                        child: Text('CANCEL'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          if(_confirmDeleteFormKey.currentState.validate()){
                            _deleteCustomer(customer);
                            Navigator.of(context).pop(); // To close the dialog
                            _deletePasswordController.clear();
                          }
                        },
                        textColor: Colors.red,
                        child: Text('DELETE'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function that deletes a customer by calling
  /// [deleteCustomer] in the [RestDataSource] class
  Future<void> _deleteCustomer(Customer customer) async {
    List<CustomerReport> reports = customer.reports;
    var api = new RestDataSource();
    try {
      for(int i = 0; i < reports.length; i++){
        await _deleteCustomerReport(customer.reports[i], customer);
      }
      await api.deleteCustomer(customer.id).then((value) {
        Constants.showMessage('Customer successfully deleted');
        _refreshData();
      }).catchError((error) {
        Constants.showMessage(error.toString());
      });
    } catch (e) {
      print(e);
      Constants.showMessage(e.toString());
    }
  }

  /// Function that deletes a customer by calling
  /// [deleteCustomer] in the [RestDataSource] class
  Future<void> _deleteCustomerReport(CustomerReport details, Customer customer) async {
    List<CustomerReportDetails> reports = details.reportDetails;
    String time = details.soldAt;
    var api = new RestDataSource();
    try {
      for(int i = 0; i < reports.length; i++){
        await _deleteReport(time, customer.name, reports[i].productName);
      }
      await api.deleteCustomerReport(customer.id, details.id).then((value) {
        print('Sales successfully deleted');
      }).catchError((error) {
        Constants.showMessage(error.toString());
      });
    } catch (e) {
      print(e);
      Constants.showMessage(e.toString());
    }
  }

  /// Function that deletes a report by calling
  /// [deleteReport] in the [RestDataSource] class
  Future<void> _deleteReport(String time, String customerName, String productName) async{
    var api = new RestDataSource();
    try {
      await api.deleteReport(time, customerName, productName).then((value) {
        print('Report successfully deleted');
      }).catchError((error) {
        Constants.showMessage(error.toString());
      });
    } catch (e) {
      print(e);
      Constants.showMessage(e.toString());
    }
  }

}
