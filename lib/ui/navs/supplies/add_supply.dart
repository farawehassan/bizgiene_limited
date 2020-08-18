import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/networking/rest_data.dart';
import 'package:bizgienelimited/styles/theme.dart' as Theme;
import 'package:bizgienelimited/utils/constants.dart';
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

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool showSpinner = false;

  /// A boolean variable to hold the value of  whether the picker should show
  bool showPicker = false;


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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Total  = ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                              width: SizeConfig.safeBlockHorizontal * 50,
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
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
                        if(_formKey.currentState.validate()){
                          confirmDialog();
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

  /// Function to confirm if a supply wants to be saved
  void confirmDialog(){
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
                  'Confirm your supply of ${Constants.money(double.parse(_amountController.text)).output.symbolOnLeft}',
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
                          showSpinner = true;
                        });
                        createSupply(
                            _nameController.text,
                            double.parse(_amountController.text),
                            _noteController.text
                        );
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
  void createSupply(String name, double amount, String notes){
    var supply = Supply();
    var api = new RestDataSource();
    try {
      supply.dealer = Constants.capitalize(name);
      supply.amount = amount.toString();
      supply.notes = notes;
      supply.received = false;
      supply.createdAt = DateTime.now().toString();

      api.addSupply(supply).then((value) {
        _nameController.clear();
        _amountController.clear();
        _noteController.clear();

        if (!mounted) return;
        setState(() {
          showSpinner = false;
        });
        Constants.showMessage('Supply successfully created');
      }).catchError((error) {
        if (!mounted) return;
        setState(() {
          showSpinner = false;
        });
        Constants.showMessage(error.toString());
      });

    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        showSpinner = false;
      });
      Constants.showMessage(e.toString());
    }
  }

}
