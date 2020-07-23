import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/model/supply_products.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/styles/theme.dart' as Theme;
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/round_icon.dart';
import 'package:bizgienelimited/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddSupply extends StatefulWidget {

  static const String id = 'add_supply_page';

  @override
  _AddSupplyState createState() => _AddSupplyState();
}

class _AddSupplyState extends State<AddSupply> {

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// A [TextEditingController] to control the input text for the dealer name
  TextEditingController _nameController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the total price
  /// of the supply
  TextEditingController _amountController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the optional notes
  TextEditingController _noteController = new TextEditingController();

  /// Variable to hold the quantity of an item recorded
  double _quantity;

  /// Variable to hold the name of an item recorded
  String _productName;

  /// Variable to hold the unitPrice of an item recorded
  double _unitPrice;

  /// Variable to hold the totalPrice of an item recorded
  double _totalPrice = 0.0;

  /// A variable holding the number of rows
  int increment = 0;

  /// A Map to hold the details of a sales record
  Map _details = {};

  /// A List to hold the Map of the data above
  List<Map> _detailsList = [];

  /// A List to hold all the supply products in a row
  List<Row> _rows = [];

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool showSpinner = false;

  /// A boolean variable to hold the value of  whether the picker should show
  bool showPicker = false;

  /// Method to capitalize the first letter of each word in a productName [string]
  /// while adding a new product or updating a particular product
  String _capitalize(String string) {
    String result = '';

    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = new List();

      if(values.length == 1){
        result = string[0].toUpperCase() + string.substring(1);
      }
      else{
        for(int i = 0; i < values.length; i++){
          if(values[i].isNotEmpty){
            valuesToJoin.add(values[i][0].toUpperCase() + values[i].substring(1));
          }
        }
        result = valuesToJoin.join(' ');
      }

    }
    return result;
  }

  /// Function to add a new row to supply sales details:
  /// [_quantity], [_productName], [_unitPrice] and [_totalPrice]
  void _addRow() {

    final TextEditingController qtyController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController productController = TextEditingController();
    final TextEditingController totalPriceController = TextEditingController();

    if (!mounted) return;
    setState(() {
      _details = {'qty':'$_quantity','productName':_productName,'unitPrice':'$_unitPrice','totalPrice':'$_totalPrice'};
      increment ++;

      _rows.add(Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              width: SizeConfig.safeBlockHorizontal * 25,//150.0,
              child: TextField(
                keyboardType: TextInputType.text,
                controller: productController,
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    _productName = _capitalize(value);
                    _details['product'] = '$_productName';
                  });
                },
                decoration: kTextFieldDecoration.copyWith(labelText: "Name"),
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              width: SizeConfig.safeBlockHorizontal * 15,//100.0,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: qtyController,
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    _quantity = double.parse(value);
                    _details['qty'] = '$_quantity';
                    if(priceController.text != null){
                      _totalPrice = double.parse(priceController.text) * double.parse(qtyController.text);
                      totalPriceController.text = _totalPrice.toString();
                      _details['totalPrice'] = '$_totalPrice';
                    }
                  });
                },
                decoration: kTextFieldDecoration.copyWith(labelText: "Qty"),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: SizeConfig.safeBlockHorizontal * 15,//80.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    _unitPrice = double.parse(value);
                    _details['unitPrice'] = '$_unitPrice';
                    _totalPrice = double.parse(value) * double.parse(qtyController.text);
                    totalPriceController.text = _totalPrice.toString();
                    _details['totalPrice'] = '$_totalPrice';
                  });
                },
                decoration: kTextFieldDecoration.copyWith(labelText: 'Unit Price'),
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              width: SizeConfig.safeBlockHorizontal * 20,//150.0,
              child: TextField(
                controller: totalPriceController,
                decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
              ),
            ),
          ),
        ],
      ));

      print(_details);

    });

    if(_details['qty'].toString().isNotEmpty && _details['productName'].toString().isNotEmpty && _details['unitPrice'].toString().isNotEmpty && _details['totalPrice'].toString().isNotEmpty){
      try {
        _detailsList.add(_details);
        _details.clear();
        qtyController.clear();
        priceController.clear();
        print(_detailsList);
      } catch (e) {
        print(e);
        Constants.showMessage("Error in products");
      }
    }

  }

  /// Function to delete a row from the supply sales at a particular [index]
  void _deleteItem(index){
    if (!mounted) return;
    setState((){
      print(index);
      _rows.removeAt(index);
      try {
        print(_detailsList[index]);
        _detailsList.removeAt(index);
        generateTotal();
      } catch (e) {
        print(e);
        Constants.showMessage(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _nameController.text = '7up Bottling Company';
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        title: Text('Add Supply'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF008752)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 80,
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: kTextFieldDecoration.copyWith(labelText: "Dealer Name"),
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter the dealer name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Products',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          AddIconButton(
                            icon: Icon(Icons.add, color: Color(0xFF008752),),
                            onPressed: (){
                              _addRow();
                            },
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: _rows.map((data) {
                            int index = _rows.indexOf(data);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _rows[index],
                                AddIconButton(
                                  icon: Icon(Icons.remove, color: Colors.red,),
                                  onPressed: (){
                                    _deleteItem(index);
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          AddIconButton(
                            icon: Icon(Icons.add, color: Color(0xFF008752),),
                            onPressed: (){
                              generateTotal();
                            },
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            "Total  = ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            width: 200.0,
                            child: TextField(
                              controller: _amountController,
                              decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextFormField(
                          decoration: kAddProductDecoration.copyWith(hintText: "Optional notes"),
                          keyboardType: TextInputType.text,
                          controller: _noteController,
                          autocorrect: true,
                          minLines: 1,
                          maxLines: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    gradient: new LinearGradient(
                        colors: [
                          Theme.ColorGradients.loginGradientStart,
                          Theme.ColorGradients.loginGradientEnd
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.ColorGradients.loginGradientEnd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 21.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                        ),
                      ),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          if(_detailsList.isNotEmpty && _detailsList != null){
                            List<SupplyProducts> products = new List();
                            for(int i = 0; i < _detailsList.length; i++){
                              if(_detailsList[i].isNotEmpty){
                                var supplyProducts = SupplyProducts();
                                supplyProducts.qty = _detailsList[i]['qty'].toString();
                                supplyProducts.name = _detailsList[i]['product'].toString();
                                supplyProducts.unitPrice = _detailsList[i]['unitPrice'].toString();
                                supplyProducts.totalPrice = _detailsList[i]['totalPrice'].toString();
                                products.add(supplyProducts);
                              }

                            }
                            if(products.isNotEmpty){
                              setState(() {
                                showSpinner = true;
                              });
                              createSupply(
                                  _nameController.text,
                                  products,
                                  double.parse(_amountController.text),
                                  _noteController.text
                              );
                            } else {
                              Constants.showMessage('No products recorded');
                            }
                          } else {
                            Constants.showMessage('No products recorded');
                          }
                        }
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generateTotal(){
    double total = 0.0;
    for(int i = 0; i < _detailsList.length; i++){
      if(_detailsList[i]['totalPrice'] != null){
        total += double.parse(_detailsList[i]['totalPrice']);
      }
    }
    setState(() {
      _amountController.text = total.toString();
    });
  }

  /// Function that creates a new supply by calling
  /// [addSupply] in the [RestDataSource] class
  void createSupply(String name, List<SupplyProducts> products, double amount, String notes){
    var supply = Supply();
    var api = new RestDataSource();
    try {
      supply.dealer = _capitalize(name);
      supply.amount = amount.toString();
      supply.products = products;
      supply.notes = notes;
      supply.received = false;
      supply.createdAt = DateTime.now().toString();

      api.addSupply(supply).then((value) {
        _nameController.clear();
        _amountController.clear();
        _noteController.clear();

        setState(() {
          showSpinner = false;
        });
        Constants.showMessage('Supply successfully created');
      }).catchError((error) {
        setState(() {
          showSpinner = false;
        });
        Constants.showMessage(error.toString());
      });

    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
      Constants.showMessage(e.toString());
    }
  }

}
