import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';

/// A StatefulWidget class that displays your supplies for the month
class MonthlySupply extends StatefulWidget {

  MonthlySupply({@required this.month});

  static const String id = 'month_supplies';

  final int month;

  @override
  _MonthlySupplyState createState() => _MonthlySupplyState();
}

class _MonthlySupplyState extends State<MonthlySupply> {

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable of double to hold the total amount value of supplies
  double _totalSupplyAmount = 0.0;

  /// Variable of int to hold the numbers of supplies
  int _supplyLength = 0;

  /// Variable of List<Supply> to hold the details of all the supply
  List<Supply> _monthSupplies = new List();

  /// Function to refresh details of the supplies for this month [widget.month]
  /// [_getSupplies()]
  Future<Null> _refreshData(){
    List<Supply> tempList = new List();
    Future<List<Supply>> supplies = futureValue.getInProgressSuppliesFromDB();
    return supplies.then((value) {
      if(value.length != 0){
        for (int i = 0; i < value.length; i++){
          if(DateTime.parse(value[i].createdAt).month == widget.month){
            tempList.add(value[i]);
          }
        }
        if (!mounted) return;
        setState(() {
          _supplyLength = tempList.length;
          _monthSupplies = tempList.reversed.toList();
        });
      } else if(value.length == 0 || value.isEmpty){
        if (!mounted) return;
        setState(() {
          _supplyLength = 0;
          _monthSupplies = [];
        });
      }
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Function to get all the supplies from the database and
  /// setting the results to [_monthSupplies]
  void _getSupplies() async {
    List<Supply> tempList = new List();
    Future<List<Supply>> receivedSupply = futureValue.getAllSuppliesFromDB();
    await receivedSupply.then((value) {
      if(value.length != 0){
        for (int i = 0; i < value.length; i++){
          if(DateTime.parse(value[i].createdAt).month == widget.month){
            tempList.add(value[i]);
            _totalSupplyAmount += double.parse(value[i].amount);
          }
        }
        if (!mounted) return;
        setState(() {
          _supplyLength = tempList.length;
          _monthSupplies = tempList.reversed.toList();
        });
      } else if(value.length == 0 || value.isEmpty){
        print(value.length);
        if (!mounted) return;
        setState(() {
          _supplyLength = 0;
          _monthSupplies = [];
        });
      }
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Converting [dateTime] in string format to return a formatted time
  /// of weekday, month, day and year
  String _getFormattedTime(String dateTime) {
    return DateFormat('MMM d, ''yyyy').format(DateTime.parse(dateTime)).toString();
  }

  /// A function to build the list of all the supplies for this month
  Widget _buildList() {
    if(_monthSupplies.length > 0 && _monthSupplies.isNotEmpty){
      return ListView.builder(
        itemCount: _monthSupplies == null ? 0 : _monthSupplies.length,
        itemBuilder: (BuildContext context, int index) {
          final paymentDate = DateTime.parse(_monthSupplies[index].createdAt);
          final received = _monthSupplies[index].received;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            height: SizeConfig.safeBlockVertical * 16.5,
            child: GestureDetector(
              onTap: (){},
              child: Material(
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                child:  Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${_getFormattedTime(paymentDate.toString())}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                            ),
                          ),
                          received
                              ? Text(
                            'Received',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF008752),
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5
                            ),
                          )
                              : Text(
                            'In progress',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF004C7F),
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            displayDialog(_monthSupplies[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    else if(_supplyLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No supplies for this month")),
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

  /// Calls [_getSupplies()] before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _getSupplies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        bottom: PreferredSize(
          preferredSize: Size(100, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 10.0),
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Total Supplies = $_supplyLength',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Total Payment = ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      '${Constants.money(_totalSupplyAmount).output.symbolOnLeft}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        title: Text('Supplies'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          color: Color(0xFF008752),
          child: Container(child: _buildList()),
        ),
      ),
    );
  }

  /// Function to display dialog of supply details [details] and optional notes
  /// [note] if it is not empty
  void displayDialog(Supply index){
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
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
                alignment: Alignment.center,
                child: Text(
                  index.foc ? 'FOC Supply': 'Normal Supply',
                  style: TextStyle(
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
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
                      '${Constants.money(double.parse(index.amount)).output.symbolOnLeft}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF008752),
                      ),
                    ),
                  ],
                ),
              ),
              index.foc
                  ? Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    padding: EdgeInsets.only(right: 10.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Commission = ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          '${index.focRate}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF008752),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    padding: EdgeInsets.only(right: 10.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Payment = ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          '${Constants.money(double.parse(index.focPayment)).output.symbolOnLeft}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF008752),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    padding: EdgeInsets.only(right: 10.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Difference = ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          '${Constants.money(double.parse(index.amount) - double.parse(index.focPayment)).output.symbolOnLeft}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF008752),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Container()
              ,
              index.notes != "" ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
                    child: Text(
                      "Notes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      index.notes,
                      style: TextStyle(
                          fontWeight: FontWeight.normal
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ) : Container(),
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
      //barrierDismissible: false,
    );
  }

}
