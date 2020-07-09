import 'package:bizgienelimited/ui/navs/other/monthly/reports_page.dart';
import 'package:bizgienelimited/ui/navs/other/products_sold.dart';
import 'package:bizgienelimited/utils/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class OtherReports extends StatefulWidget {

  static const String id = 'other_report_page';

  @override
  _OtherReportsState createState() => _OtherReportsState();
}

class _OtherReportsState extends State<OtherReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Center(child: Text('Other Reports')),
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
                cardChild: 'My Customers',
                onPress: (){
                  //Navigator.pushNamed(context, DailyReportList.id);
                },
              ),
              ReusableCard(
                cardChild: 'Monthly Reports',
                onPress: (){
                  Navigator.pushNamed(context, ReportPage.id);
                },
              ),
              ReusableCard(
                cardChild: 'Products Sold',
                onPress: (){
                  Navigator.pushNamed(context, ProductsSold.id);
                },
              ),
              SizedBox(height: 40.0,),
            ],
          ),
        ),
      ),
    );
  }
}
