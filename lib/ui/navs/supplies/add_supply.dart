import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/styles/theme.dart' as Theme;
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/reusable_card.dart';
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

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _normalKey = GlobalKey<FormState>();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _focKey = GlobalKey<FormState>();

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// A [TextEditingController] to control the input text for the dealer name
  TextEditingController _nameController = new TextEditingController();


  /// A [TextEditingController] to control the input text for the normal payment
  /// of the supply
  TextEditingController _normalPaymentController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the optional notes
  TextEditingController _noteController = new TextEditingController();



  /// A [TextEditingController] to control the input text for the for amount
  /// of the supply
  TextEditingController _focAmountController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the for amount
  /// of the supply
  TextEditingController _focPaymentController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the for amount
  /// of the supply
  TextEditingController _focDifferenceController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the foc rate
  /// of the supply
  TextEditingController _focRateController = new TextEditingController();


  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// A boolean variable to hold the normal supply if selected
  bool _normalSupplyType = true;

  /// A boolean variable to hold the foc supply if selected
  bool _focSupplyType = false;


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
        inAsyncCall: _showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF008752)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 80,
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: kTextFieldDecoration.copyWith(labelText: "Dealer Name"),
                      keyboardType: TextInputType.text,
                      controller: _nameController,
                      readOnly: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SelectSupplyCard(
                        isSelected: _normalSupplyType,
                        text: 'Normal',
                        onPress: (){
                          if(!mounted) return;
                          setState(() {
                            if(_focSupplyType){
                              _focSupplyType = false;
                              _normalSupplyType = true;
                            }
                          });
                        },
                      ),
                      SelectSupplyCard(
                        isSelected: _focSupplyType,
                        text: 'FOC',
                        onPress: (){
                          if(!mounted) return;
                          setState(() {
                            if(_normalSupplyType){
                              _normalSupplyType = false;
                              _focSupplyType = true;
                            }
                          });
                        }
                      ),
                    ],
                  ),
                  _normalSupplyType ? _normalSupply() : _focSupply()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget that displays a form for a normal supply type
  /// if [_normalSupplyType] == true
  /// It returns a [SingleChildScrollView]
  Widget _normalSupply(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _normalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Total  = ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                          width: SizeConfig.safeBlockHorizontal * 50,
                          child: TextFormField(
                            controller: _normalPaymentController,
                            keyboardType: TextInputType.number,
                            decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter your payment';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: kAddProductDecoration.copyWith(hintText: "Products you intend to get"),
                    keyboardType: TextInputType.multiline,
                    controller: _noteController,
                    autocorrect: true,
                    minLines: 1,
                    maxLines: 40,
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
                    if(_normalKey.currentState.validate()){
                      confirmDialog(_normalPaymentController.text, false);
                    }
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget that displays a form for a for supply type
  /// if [_focSupplyType] == true
  /// It returns a [SingleChildScrollView]
  Widget _focSupply(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _focKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  width: SizeConfig.safeBlockHorizontal * 60,
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _focAmountController,
                    keyboardType: TextInputType.number,
                    decoration: kTextFieldDecoration.copyWith(labelText: 'Total',),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your total';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  width: SizeConfig.safeBlockHorizontal * 60,
                  child: TextFormField(
                    controller: _focRateController,
                    keyboardType: TextInputType.text,
                    decoration: kTextFieldDecoration.copyWith(labelText: 'FOC Rate',),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your FOC rate';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  width: SizeConfig.safeBlockHorizontal * 60,
                  child: TextFormField(
                    controller: _focPaymentController,
                    keyboardType: TextInputType.number,
                    decoration: kTextFieldDecoration.copyWith(labelText: 'Payment',),
                    onChanged: (value){
                      _focDifferenceController.text = (
                          double.parse(_focAmountController.text) -
                              double.parse(value)
                      ).toString();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your payment';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  width: SizeConfig.safeBlockHorizontal * 60,
                  child: TextFormField(
                    controller: _focDifferenceController,
                    keyboardType: TextInputType.number,
                    decoration: kTextFieldDecoration.copyWith(labelText: 'Difference',),
                    readOnly: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your payment';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: kAddProductDecoration.copyWith(hintText: "Products you intend to get"),
                    keyboardType: TextInputType.multiline,
                    controller: _noteController,
                    autocorrect: true,
                    minLines: 1,
                    maxLines: 40,
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
                    if(_focKey.currentState.validate()){
                      confirmDialog(_focAmountController.text, true);
                    }
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Function to confirm if a supply wants to be saved
  void confirmDialog(String amount, bool foc){
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
                  foc
                      ? 'Confirm your supply of ${Constants.money(double.parse(amount)).output.symbolOnLeft}'
                      : 'Confirm your foc supply of ${Constants.money(double.parse(amount)).output.symbolOnLeft}' ,
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
                        if (!mounted) return;
                        setState(() {
                          _showSpinner = true;
                        });
                        createSupply(foc);
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

  /// Function that creates a new supply by calling
  /// [addSupply] in the [RestDataSource] class
  void createSupply(bool foc){
    var supply = Supply();
    var api = new RestDataSource();
    try {
      if(foc){
        supply.dealer = Constants.capitalize(_nameController.text);
        supply.amount = _focAmountController.toString();
        supply.foc = true;
        supply.focRate = _focRateController.text;
        supply.focPayment = _focPaymentController.text;
        supply.notes = _noteController.text;
        supply.received = false;
        supply.createdAt = DateTime.now().toString();
      }
      else if(!foc){
        supply.dealer = Constants.capitalize(_nameController.text);
        supply.amount = _normalPaymentController.text;
        supply.foc = false;
        supply.notes = _noteController.text;
        supply.received = false;
        supply.createdAt = DateTime.now().toString();
      }

      api.addSupply(supply).then((value) {
        if(foc){
          _focAmountController.clear();
          _focPaymentController.clear();
          _focRateController.clear();
          _focDifferenceController.clear();
        }
        else if(!foc){
          _normalPaymentController.clear();
        }
        _noteController.clear();

        if (!mounted) return;
        setState(() {
          _showSpinner = false;
        });
        Constants.showMessage('Supply successfully created');
        Navigator.of(context).pop();
      }).catchError((error) {
        if (!mounted) return;
        setState(() {
          _showSpinner = false;
        });
        Constants.showMessage(error.toString());
      });

    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        _showSpinner = false;
      });
      Constants.showMessage(e.toString());
    }
  }

}
