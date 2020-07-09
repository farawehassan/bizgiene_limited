import 'package:bizgienelimited/model/reportsDB.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';
import 'daily_report_value.dart';
import 'future_values.dart';

/// A StatefulWidget class creating a pie chart for my daily report records
class DailyChart extends StatefulWidget {

  static const String id = 'daily_chart';

  @override
  _DailyChartState createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {

  /// Instantiating a class of the [DailyReportValue]
  var reportValue = DailyReportValue();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A variable holding the list of primary colors and accents colors
  List<Color> colours = (Colors.primaries.cast<Color>() + Colors.accents.cast<Color>());

  /// A variable holding my daily report data as a map
  var data = {};

  /// Creating a map to my [data]'s product name to it's quantity for my charts
  Map<String, double> dataMap = Map();

  /// A variable holding the length my daily report data
  int _dataLength;

  /// A variable holding the list of colors needed for my pie chart
  List<Color> colorList = [];

  /// Function to get today's report and map [data] it's product name to
  /// its quantity accordingly
  /// It also calls the function [getColors()]
  void getReports() async {
    Future<List<Reports>> report = futureValue.getAllReportsFromDB();
    await report.then((value) {
      if (!mounted) return;
      setState(() {
        _dataLength = 0;
        for(int i = 0; i < value.length; i++){
          if(reportValue.checkIfToday(value[i].createdAt)){
            _dataLength += 1;
            if(data.containsKey(value[i].productName)){
              data[value[i].productName] = (double.parse(data[value[i].productName]) + double.parse(value[i].quantity)).toString();
            }else{
              data[value[i].productName] = '${value[i].quantity}';
            }
          }
        }
        print(data);
      });
      print(_dataLength);
      getColors();
    }).catchError((onError){
      _showMessage(onError);
    });
  }

  /// Function to get the amount of colors needed for the pie chart and map
  /// [data] to [dataMap]
  void getColors() {
    for(int i = 0; i < data.length; i++){
      colorList.add(colours[i]);
    }
    data.forEach((k,v) {
      dataMap.putIfAbsent("$k", () => double.parse('$v'));
    });
  }

  /// It calls [getReports()] while initializing my state
  @override
  void initState() {
    super.initState();
    getReports();
  }

  /// Function to build my pie chart if dataMap is not empty and it's length is
  /// > 0 using pie_chart package
  Widget _buildChart(){
    if(dataMap.length > 0 && dataMap.isNotEmpty){
      return PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: false,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.ring,
      );
    }
    else if(_dataLength == 0){
      return Container(
        alignment: AlignmentDirectional.center,
        child: Center(child: Text("No sales yet")),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildChart(),
      ),
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