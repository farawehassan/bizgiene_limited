import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/utils/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'monthly_reports.dart';

/// A StatelessWidget class that displays all the months in a year
// ignore: must_be_immutable
class ReportPage extends StatelessWidget {

  static const String id = 'reports_page';
  var futureValue = FutureValues();

  /// Instantiating a class of the [FutureValues]
  @override
  Widget build(context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Center(child: Text('Monthly Reports')),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          ReusableCard(
            cardChild: 'January',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jan')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'Febraury',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Feb')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'March',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Mar')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'April',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Apr')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'May',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'May')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'June',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jun')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'July',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Jul')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'August',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Aug')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'September',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Sep')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'October',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Oct')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'November',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Nov')),
              );
            },
          ),
          ReusableCard(
            cardChild: 'December',
            onPress: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MonthReport(month: 'Dec')),
              );
            },
          ),
        ],
      ),
    );
  }

}

