import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/model/supply_products.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SupplyInProgress extends StatefulWidget {

  static const String id = 'supply_in_progress_page';

  @override
  _SupplyInProgressState createState() => _SupplyInProgressState();
}

class _SupplyInProgressState extends State<SupplyInProgress> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable of int to hold the numbers of supplies
  int _supplyLength;

  /// Variable of List<Supply> to hold the details of all the supply
  List<Supply> _supplyInProgress = new List();

  /// Function to refresh details of the Available products
  /// by calling [_getNames()]
  void _refreshData(){
    if (!mounted) return;
    setState(() {
      _getSupplyInProgress();
    });
  }

  /// Converting [dateTime] in string format to return a formatted time
  /// of weekday, month, day and year
  String _getFormattedTime(String dateTime) {
    return DateFormat('MMM d, ''yyyy').format(DateTime.parse(dateTime)).toString();
  }

  /// Function to get all the supplies from the database and
  /// setting the results to [_supplyInProgress]
  void _getSupplyInProgress() async {
    List<Supply> tempList = new List();
    Future<List<Supply>> supplies = futureValue.getInProgressSuppliesFromDB();
    await supplies.then((value) {
      print(value);
      if(value.length != 0){
        print(value.length);
        for (int i = 0; i < value.length; i++){
          tempList.add(value[i]);
        }
        if (!mounted) return;
        setState(() {
          _supplyLength = tempList.length;
          _supplyInProgress = tempList.reversed.toList();
        });
      } else if(value.length == 0 || value.isEmpty){
        print(value.length);
        if (!mounted) return;
        setState(() {
          _supplyLength = 0;
          _supplyInProgress = [];
        });
      }
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// A function to build the list of the supply in progress
  Widget _buildList() {
    if(_supplyInProgress.length > 0 && _supplyInProgress.isNotEmpty){
      return ListView.builder(
        itemCount: _supplyInProgress == null ? 0 : _supplyInProgress.length,
        itemBuilder: (BuildContext context, int index) {
          final paymentDate = DateTime.parse(_supplyInProgress[index].createdAt);
          final now = DateTime.now();
          final difference = now.difference(paymentDate).inDays;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            height: SizeConfig.safeBlockVertical * 15,
            child: GestureDetector(
              onTap: (){},
              onLongPress: (){
                confirmDeleteDialog(_supplyInProgress[index].id);
              },
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
                          Row(
                            children: <Widget>[
                              Text(
                                '${_supplyInProgress[index].dealer}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                ),
                              ),
                              SizedBox(width: 6.0,),
                              Text(
                                '${_getFormattedTime(paymentDate.toString())}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                                ),
                              ),
                            ],
                          ),
                          //SizedBox(height: 6.0,),
                          difference == 0
                              ? Text(
                            'Payed today',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF004C7F),
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5
                            ),
                          )
                              : Text(
                            'Payed ${difference.toString()} days ago',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF004C7F),
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            List<SupplyProducts> products = _supplyInProgress[index].products;
                            List<Map> _supplyDetails = new List();
                            Map data = {};
                            for(int i = 0 ; i < products.length; i++){
                              data = {'qty':'${products[i].qty}', 'productName': '${products[i].name}', 'unitPrice': '${products[i].unitPrice}', 'totalPrice': '${products[i].totalPrice}'};
                              _supplyDetails.add(data);
                            }
                            displayDialog(_supplyInProgress[index].id, _supplyDetails, double.parse(_supplyInProgress[index].amount), _supplyInProgress[index].notes);
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
        child: Center(child: Text("No supplies yet")),
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
  void initState() {
    super.initState();
    _getSupplyInProgress();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: _buildList(),
    );
  }

  /// Function to display dialog of supply details [details] the optional notes
  /// [note] if it is not empty
  void displayDialog(String id, List<Map> details, double total, String note){
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
              _dataTable(details, total),
              note != "" ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
                    child: Text(
                      "Extra Notes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      note,
                      style: TextStyle(
                          fontWeight: FontWeight.normal
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ) : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                        confirmDialog(id);
                      },
                      textColor: Color(0xFF008752),
                      child: Text('UPDATE'),
                    ),
                  ),
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
            ],
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function to confirm if a supply is received and set it true
  void confirmDialog(String id){
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
                  'Are you sure the supply is received',
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
                        updateSupply(id);
                      },
                      textColor: Color(0xFF008752),
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

  /// Function to confirm if a supply wants to be deleted
  void confirmDeleteDialog(String id){
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
                  'Are you sure you want to delete this supply',
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
                        deleteSupply(id);
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

  /// Creating a [DataTable] widget from a List of Map [supplyList]
  /// using QTY, PRODUCT, UNIT, TOTAL as DataColumn and
  /// the values of each DataColumn in the [supplyList] as DataRows
  SingleChildScrollView _dataTable(List<Map> supplyList, double total){
    print(supplyList);
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
            rows: supplyList.map((supply) {
              return DataRow(
                  cells: [
                    DataCell(
                      Text(supply['qty'].toString()),
                    ),
                    DataCell(
                      Text(supply['productName'].toString()),
                    ),
                    DataCell(
                      Text(Constants.money(double.parse(supply['unitPrice'])).output.symbolOnLeft.toString()),
                    ),
                    DataCell(
                      Text(Constants.money(double.parse(supply['totalPrice'])).output.symbolOnLeft.toString()),
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
                  '${Constants.money(total).output.symbolOnLeft}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF008752),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Function that updates a supply to received by calling
  /// [receivedSupply] in the [RestDataSource] class
  void updateSupply(String id){
    var api = new RestDataSource();
    try {
      api.receivedSupply(id, true).then((value) {
        Constants.showMessage('Supply successfully received');
        _refreshData();
      }).catchError((error) {
        Constants.showMessage(error.toString());
      });

    } catch (e) {
      print(e);
      Constants.showMessage(e.toString());
    }
  }

  /// Function that deletes a supply by calling
  /// [receivedSupply] in the [RestDataSource] class
  void deleteSupply(String id){
    var api = new RestDataSource();
    try {
      api.deleteSupply(id).then((value) {
        Constants.showMessage('Supply successfully deleted');
        _refreshData();
      }).catchError((error) {
        Constants.showMessage(error.toString());
      });

    } catch (e) {
      print(e);
      Constants.showMessage(e.toString());
    }
  }

}
