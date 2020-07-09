import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/bloc/profit_charts.dart';
import 'package:bizgienelimited/bloc/year_line_charts.dart';
import 'package:bizgienelimited/model/store_details.dart';
import 'package:bizgienelimited/ui/register/create_worker.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/reusable_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

/// A StatefulWidget class that displays the business's profile
/// only the admin can have access to this page
class Profile extends StatefulWidget {

  static const String id = 'profile_page';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A string value to hold the cost price net worth of the products
  String _cpNetWorth= '';

  /// A string value to hold the selling price net worth of the products
  String _spNetWorth = '';

  /// A double value to hold the total number of items available
  double _numberOfItems = 0.0;

  /// A double value to hold the total profit made so far
  double _totalProfit = 0.0;

  /// Convert a double [value] to naira
  FlutterMoneyFormatter _money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  /// A function to set the values [_cpNetWorth], [_spNetWorth], [_numberOfItems],
  /// from the [StoreDetails] model fetching from the database
  void _getStoreValues() async {
    Future<StoreDetails> details = futureValue.getStoreDetails();
    await details.then((value) {
      if (!mounted) return;
      setState(() {
        _cpNetWorth = _money(value.cpNetWorth).output.symbolOnLeft;
        _spNetWorth = _money(value.spNetWorth).output.symbolOnLeft;
        _numberOfItems = value.totalItems;
        _totalProfit = value.totalProfitMade;
      });
    }).catchError((onError){
      _showMessage(onError);
    });
  }

  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }

  /// Calling [_getStoreValues()] and [_getReports()] before the page loads
  @override
  void initState() {
    super.initState();
    _getStoreValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFf2f4fb),
      appBar: GradientAppBar(
        title: Text('Bizgenie Limited'),
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.profileChoices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              //color: Color(0xFFF9FBFD),
              elevation: 14.0,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              shadowColor: Color(0xFF004C7F),
              child: Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.only(bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: 'displayPicture',
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF004C7F),
                              maxRadius: 80.0,
                              minRadius: 40.0,
                              backgroundImage: AssetImage('Assets/images/mum.JPG'),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Mrs Monsurat Bolanle Kosoko",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "mbkosoko@yahoo.com",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'CP Net Worth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$_cpNetWorth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF008752),
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'SP Net Worth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$_spNetWorth',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF008752),
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              margin: EdgeInsets.all(8.0),
              height: 200.0,
              child: Material(
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                child:  Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        Color(0xFF008752),
                        Color(0xFF004C7F)
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],

                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sales by Month',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      PointsLineChart(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              margin: EdgeInsets.all(4.0),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProfileCard(
                        cardChild: ProfitCharts(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ProfileCard(
                            cardChild: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:Text(
                                    'Profit Made',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '${_money(_totalProfit).output.symbolOnLeft}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Color(0xFF008752),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          ProfileCard(
                            cardChild: Column(
                              children: <Widget>[
                                Text(
                                  'Number of Items',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '$_numberOfItems',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Color(0xFF008752),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A function to set the routes to navigate to when an option is pressed with
  /// the value [choice]
  void choiceAction(String choice){
    if(choice == Constants.Create){
      Navigator.pushNamed(context, CreateWorker.id);
    }
  }
}

