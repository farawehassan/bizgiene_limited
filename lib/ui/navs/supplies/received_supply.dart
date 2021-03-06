import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceivedSupply extends StatefulWidget {

  static const String id = 'received_supply_page';

  @override
  _ReceivedSupplyState createState() => _ReceivedSupplyState();
}

class _ReceivedSupplyState extends State<ReceivedSupply> {

  /// GlobalKey of a my RefreshIndicatorState to refresh my list items in the page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable of int to hold the numbers of supplies
  int _supplyLength;

  /// Variable of List<Supply> to hold the details of all the supply
  List<Supply> _receivedSupplies = new List();

  /// Function to refresh details of the received supplies similar to
  /// [_getReceivedSupply()]
  Future<Null> _refreshData(){
    List<Supply> tempList = new List();
    Future<List<Supply>> receivedSupply = futureValue.getReceivedSuppliesFromDB();
    return receivedSupply.then((value) {
      if(value.length != 0){
        tempList.addAll(value);
        if (!mounted) return;
        setState(() {
          _supplyLength = tempList.length;
          _receivedSupplies = tempList.reversed.toList();
        });
      } else if(value.length == 0 || value.isEmpty){
        if (!mounted) return;
        setState(() {
          _supplyLength = 0;
          _receivedSupplies = [];
        });
      }
    }).catchError((error){
      print(error);
      Constants.showMessage(error.toString());
    });
  }

  /// Function to get all the supplies from the database and
  /// setting the results to [_receivedSupplies]
  void _getReceivedSupply() async {
    List<Supply> tempList = new List();
    Future<List<Supply>> receivedSupply = futureValue.getReceivedSuppliesFromDB();
    await receivedSupply.then((value) {
      if(value.length != 0){
        tempList.addAll(value);
        if (!mounted) return;
        setState(() {
          _supplyLength = tempList.length;
          _receivedSupplies = tempList.reversed.toList();
        });
      } else if(value.length == 0 || value.isEmpty){
        if (!mounted) return;
        setState(() {
          _supplyLength = 0;
          _receivedSupplies = [];
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

  /// A function to build the list of the received supply
  Widget _buildList() {
    if(_receivedSupplies.length > 0 && _receivedSupplies.isNotEmpty){
      return ListView.builder(
        itemCount: _receivedSupplies == null ? 0 : _receivedSupplies.length,
        itemBuilder: (BuildContext context, int index) {
          final paymentDate = DateTime.parse(_receivedSupplies[index].createdAt);
          final time = DateTime.parse(_receivedSupplies[index].receivedAt);
          final difference = time.difference(paymentDate).inDays;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            height: SizeConfig.safeBlockVertical * 15,
            child: GestureDetector(
              onTap: (){},
              onLongPress: (){
                _confirmDeleteDialog(_receivedSupplies[index].id);
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
                                '${_receivedSupplies[index].dealer}',
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
                              SizedBox(width: 5.0,),
                              _receivedSupplies[index].foc ? Text(
                                '(FOC)',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.6,
                                ),
                              ) : Text('')
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Received - ',
                                style: TextStyle(
                                  color: Color(0xFF008752),
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                ),
                              ),
                              Text(
                                'in ${difference.toString()} days',
                                style: TextStyle(
                                  //color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5
                                ),
                              ),
                            ],
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
                            _displayDialog(_receivedSupplies[index]);
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
        child: Center(child: Text("No received supplies yet")),
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

  /// Calls [_getReceivedSupply()] before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _getReceivedSupply();
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

  /// Function to display dialog of supply details [details] the optional notes
  /// [note] if it is not empty
  void _displayDialog(Supply index){
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

  /// Function to confirm if a supply wants to be deleted
  void _confirmDeleteDialog(String id){
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
                        _deleteSupply(id);
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

  /// Function that deletes a supply by calling
  /// [deleteSupply] in the [RestDataSource] class
  void _deleteSupply(String id){
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
