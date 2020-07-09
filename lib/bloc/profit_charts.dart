import 'package:bizgienelimited/model/linear_sales.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';
import 'future_values.dart';

/// A StatefulWidget class creating a pie chart for my quarterly month profits
class ProfitCharts extends StatefulWidget {

  static const String id = 'profit_charts';

  @override
  _ProfitChartsState createState() => _ProfitChartsState();
}

class _ProfitChartsState extends State<ProfitCharts> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A variable holding the list of colors needed for my pie chart
  List<Color> colorList = [
    Color(0xFF004C7F),
    Color(0xfff3af00),
    Color(0xffec3337),
    Color(0xFF008752),
  ];

  /// A variable holding the list total profit made
  List<double> profitMade = [];

  /// A variable holding my average value for all the month
  double average = 0;

  /// Creating a map to my data's product name to it's quantity for my pie chart
  Map<String, double> dataMap = Map();

  void getReports() async {
    Future<List<LinearSales>> report = futureValue.getYearReports();
    await report.then((value) {
      if (!mounted) return;
      setState(() {
        for(int i = 0; i < value.length; i++){
          profitMade.add(value[i].profit);
        }
      });
      getQuarterlyMonth();
    }).catchError((onError){
      _showMessage(onError);
    });
  }

  /// Function to set all the month's profit made and
  /// calculate its average quarterly
  void getQuarterlyMonth(){
    if (!mounted) return;
    setState(() {
      dataMap['Q1'] = profitMade[0] + profitMade[1] + profitMade[2];
      dataMap['Q2'] = profitMade[3] + profitMade[4] + profitMade[5];
      dataMap['Q3'] = profitMade[6] + profitMade[7] + profitMade[8];
      dataMap['Q4'] = profitMade[9] + profitMade[10] + profitMade[11];

      average = (dataMap['Q1'] + dataMap['Q2'] + dataMap['Q3'] + dataMap['Q4']) / 4;
    });
  }

  /// Function to build my pie chart if dataMap is not empty and it's length is
  /// > 0 using pie_chart package
  Widget _buildChart(){
    if(dataMap.length > 0 && dataMap.isNotEmpty){
      return PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 8.0,
        chartRadius: MediaQuery.of(context).size.width / 4.7,
        showChartValuesInPercentage: false,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.left,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.disc,
      );
    }
    else{
      Container();
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

  /// It calls [getReports()] while initializing my state
  @override
  void initState() {
    super.initState();
    getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Quarterly Profit',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '+ N$average',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0xFF008752),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: _buildChart(),
        ),
      ],
    );
  }

  /// Using flutter toast to display a toast message [message]
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }

}

