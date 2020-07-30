import 'package:bizgienelimited/bloc/daily_report_chart.dart';
import 'package:bizgienelimited/bloc/daily_report_value.dart';
import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/reportsDB.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/reusable_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'daily_report_list.dart';

/// A StatefulWidget class that displays the Today's Reports details
class DailyReports extends StatefulWidget {

  static const String id = 'daily_reports';

  @override
  _DailyReportsState createState() => _DailyReportsState();
}

class _DailyReportsState extends State<DailyReports> {

  /// Instantiating a class of the [DailyReportValue]
  var reportValue = DailyReportValue();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable to hold the total availableCash of today's report
  double _availableCash = 0.0;

  /// Variable to hold the total totalTransfer of today's report
  double _totalTransfer = 0.0;

  /// Variable to hold the outstanding payment in today's report
  double _outstandingPayment = 0.0;

  /// Variable to hold the total ProfitMade in today's report
  double _totalProfitMade = 0.0;

  /// Variable to hold the type of the user logged in
  String _user;

  /// Setting the current user logged in to [_user]
  void _getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      _user = user.type;
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  /// Calculating profit of a particular DailyReportsData [data],
  ///  profitMade = data's quantity * (data's unitPrice - data's costPrice)
  ///
  /// Increment [_totalProfitMade] with the result of profitMade
  void _calculateProfit(Reports data) async {
    if (!mounted) return;
    setState(() {
      _totalProfitMade += double.parse(data.quantity) * (double.parse(data.unitPrice) - double.parse(data.costPrice));
    });
  }

  /// Getting today's reports from the dailyReportsDatabase based on time
  /// Calls [_calculateProfit(report)] on every report that is today
  ///
  /// Increments [_availableCash] with the value of report's totalPrice,
  /// If the payment's mode of a report is cash
  ///
  /// Increments [_totalTransfer] with the value of report's totalPrice,
  /// If the payment's mode of a report is transfer
  void _getReports() async {
    Future<List<Reports>> report = futureValue.getAllReportsFromDB();
    await report.then((value) {
      if (!mounted) return;
      setState(() {
        for(int i = 0; i < value.length; i++){
          if(reportValue.checkIfToday(value[i].createdAt)){
            _calculateProfit(value[i]);
            if(value[i].paymentMode == 'Cash'){
              _availableCash += double.parse(value[i].totalPrice);
            }
            else if(value[i].paymentMode == 'Transfer'){
              _totalTransfer += double.parse(value[i].totalPrice);
            }
          }
        }
      });
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Function to get all the outstanding payment from today's report and set
  /// the value to [_outstandingPayment]
  void _getOutstandingPayment() async {
    Future<double> value = reportValue.getTodayOutstandingPayment();
    await value.then((value) {
      if (!mounted) return;
      setState(() {
        _outstandingPayment = value;
      });
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Calls [_getCurrentUser()], [_getReports()] and [_getOutstandingPayment()]
  /// before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getReports();
    _getOutstandingPayment();
  }

  /// Building a Scaffold Widget to display today's report, [DailyChart],
  /// [_availableCash], [_totalTransfer], totalCash and [_totalProfitMade] if
  /// the user is an Admin
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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ReusableCard(
                cardChild: 'Today\'s Sales',
                onPress: (){
                  Navigator.pushNamed(context, DailyReportList.id);
                },
              ),
              SizedBox(height: 40.0,),
              DailyChart(),
              SizedBox(height: 40.0,),
              Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    titleText('Transferred Cash: ${Constants.money(_totalTransfer).output.symbolOnLeft}'),
                    SizedBox(height: 8.0,),
                    titleText('Total Cash: ${Constants.money(_availableCash + _totalTransfer).output.symbolOnLeft}'),
                    SizedBox(height: 8.0,),
                    titleText('Outstanding Payment: ${Constants.money(_outstandingPayment).output.symbolOnLeft}'),
                    SizedBox(height: 8.0,),
                    titleText('Available Cash: ${Constants.money(_availableCash - _outstandingPayment).output.symbolOnLeft}'),
                    SizedBox(height: 8.0,),
                    _user == 'Admin' ? titleText('Profit made: ${Constants.money(_totalProfitMade).output.symbolOnLeft}') : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}