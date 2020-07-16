import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/bloc/product_suggestions.dart';
import 'package:bizgienelimited/database/user_db_helper.dart';
import 'package:bizgienelimited/model/productDB.dart';
import 'package:bizgienelimited/styles/theme.dart' as Them;
import 'package:bizgienelimited/ui/navs/other/other_reports.dart';
import 'package:bizgienelimited/ui/navs/receipt/receipt_page.dart';
import 'package:bizgienelimited/utils/constants.dart';
import 'package:bizgienelimited/utils/round_icon.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile_page.dart';
import '../welcome_screen.dart';
import 'available_drinks.dart';
import 'daily/daily_reports.dart';
import 'other/supply_page.dart';

/// A StatefulWidget class that displays the sales record
class MyHomePage extends StatefulWidget {

  static const String id = 'home_page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// Switch button for toggling between light mode and dark mode
  bool _enabled = false;

  /// Function for toggling between light mode and dark mode
  void themeSwitch(context) {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  /// Variable to hold the quantity of an item recorded
  double _quantity;

  /// Variable to hold the name of an item recorded
  String _selectedProduct;

  /// Variable to hold the costPrice of an item recorded
  double _costPrice;

  /// Variable to hold the unitPrice of an item recorded
  double _unitPrice;

  /// Variable to hold the totalPrice of an item recorded
  double _totalPrice;

  /// A variable holding the number of rows
  int increment = 0;

  /// A Map to hold the details of a sales record
  Map _details = {};

  /// A List to hold the Map of the data above
  List<Map> _detailsList = [];

  /// A Map to hold the product's name to its current quantity
  Map products = {};

  /// A Map to hold the product's name to its cost price
  var productCost = Map();

  /// A List to hold the names of all the availableProducts in the database
  List<String> availableProducts = [];

  /// A List to hold all the sales records in a row
  List<Row> _rows = [];

  /// Variable to hold the name of the user logged in
  String _user;

  /// Setting the current user's name logged in to [_username]
  void _getCurrentUser() async {
    await futureValue.getCurrentUser().then((user) {
      _user = user.type;
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  /// Function to fetch all the available product's names from the database to
  /// [availableProducts]
  void _availableProductNames() {
    Future<List<Product>> productNames = futureValue.getAvailableProductsFromDB();
    productNames.then((value) {
      for (int i = 0; i < value.length; i++){
        availableProducts.add(value[i].productName);
        products[value[i].productName] = double.parse(value[i].currentQuantity);
        productCost[value[i].productName] = double.parse(value[i].costPrice);
      }
    }).catchError((error){
      print(error);
      _showMessage(error.toString());
    });
  }

  /// Calls [_getCurrentUser()] before the class builds its widgets
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getThemeBoolValuesSF();
  }

  /// Function to add a new row to record sales details:
  /// [_quantity], [_selectedProduct], [_costPrice], [_unitPrice] and [_totalPrice]
  void _addRow() {
    availableProducts.clear();
    products.clear();
    productCost.clear();
    _availableProductNames();

    final TextEditingController qtyController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController productController = TextEditingController();
    final TextEditingController totalPriceController = TextEditingController();

    if (!mounted) return;
    setState(() {
      _details = {'qty':'$_quantity','product':_selectedProduct,'costPrice':'$_costPrice','unitPrice':'$_unitPrice','totalPrice':'$_totalPrice'};
      increment ++;

      _rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              width: 80.0,
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
                decoration: kTextFieldDecoration.copyWith(hintText: '0'),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: 300.0,
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: productController,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Product'),
                ),
                suggestionsCallback: (pattern) {
                  return AvailableProducts.getSuggestions(pattern, availableProducts);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  productController.text = suggestion;
                  _selectedProduct = productController.text;
                  _details['product'] = '$_selectedProduct';
                  if (!mounted) return;
                  setState(() {
                    _costPrice = productCost[_selectedProduct];
                    _details['costPrice'] = '$_costPrice';
                    print(_costPrice);
                  });
                },
                onSaved: (value) {
                  _selectedProduct = value;
                  _details['product'] = '$_selectedProduct';
                  if (!mounted) return;
                  setState(() {
                    _costPrice = productCost[_selectedProduct];
                    _details['costPrice'] = '$_costPrice';
                  });
                },
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: 100.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                decoration: kTextFieldDecoration.copyWith(hintText: '0.0'),
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: 150.0,
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

    if(_details['qty'].toString().isNotEmpty && _details['product'].toString().isNotEmpty && _details['costPrice'].toString().isNotEmpty && _details['unitPrice'].toString().isNotEmpty && _details['totalPrice'].toString().isNotEmpty){
      try {
        _detailsList.add(_details);
        _details.clear();
        qtyController.clear();
        priceController.clear();
        print(_detailsList);
      } catch (e) {
        print(e);
        _showMessage("Error in records");
      }
    }

  }

  /// Function to delete a row from the record sales at a particular [index]
  void _deleteItem(index){
    if (!mounted) return;
    setState((){
      print(index);
      _rows.removeAt(index);
      try {
        print(_detailsList[index]);
        _detailsList.removeAt(index);
      } catch (e) {
        print(e);
        _showMessage(e);
      }
    });
  }

  /// Function to undo deletion of a row from the record sales by replacing
  /// [item] at a particular [index]
  /*void _undoDeletion(index, item){
    setState((){
      _rows.insert(index, item);
      _detailsList.insert(index, item);
    });
  }*/

  /// Function to check whether a product's quantity is not more than the
  /// buyer's quantity
  /// It returns false if it does and true if it does not
  bool _checkProductQuantity(String name, double qty) {
    bool response = false;
    if(products.containsKey(name) && products[name] >= qty){
      response = true;
    }
    return response;
  }

  /// Function to check whether a product's quantity is not more than the
  /// buyer's quantity by calling [_checkProductQuantity()]
  /// It returns true if it does and false if it does not
  bool _checkQuantity() {
    bool response = false;
    try {
      for(int i = 0; i < _detailsList.length; i++){
        if (_checkProductQuantity(_detailsList[i]['product'], double.parse(_detailsList[i]['qty'])) == false){
          response = true;
        }
      }
    } catch (e) {
      print(e);
      _showMessage("Error in fetching sales");
      response = true;
    }
    print(response);
    return response;
  }

  /// Building a Scaffold Widget to display an AppBar that sends [_detailsList]
  /// when the send icon is pressed, a listView of dismissible widget
  /// of [_rows], a floatingActionButton to add a new row when pressed by
  /// calling [_addRow()] and a drawer to show other screens and details when pressed
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Center(child: Text('Sales Record')),
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              if (_detailsList.isNotEmpty && _checkQuantity() == false){
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Receipt(sentProducts: _detailsList)),
                  );
                } catch (e) {
                  print(e);
                  _showMessage("Error in records");
                }
              }
              else{
                _showMessage("Error in records or no records");
              }
            },
          ),
        ],
      ),
      body:  Padding(
        padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  titleText("QTY"),
                  titleText("PRODUCT"),
                  titleText("PRICE"),
                  titleText("TOTAL"),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: _rows.map((data) {
                    int index = _rows.indexOf(data);
                    return Dismissible(
                      key: new ObjectKey(_rows[index]),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _deleteItem(index);
                          increment--;
                        });
                      },
                      background: Container(color: Colors.red),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _rows[index],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _showProfile();
                    },
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Them.ColorGradients.loginGradientEnd,
                              Them.ColorGradients.loginGradientStart
                            ],
                            begin: const FractionalOffset(0.2, 0.2),
                            end: const FractionalOffset(1.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      accountName: Text("Bizgenie Limited"),
                      accountEmail: Text("mbkosoko@yahoo.com"),
                      currentAccountPicture: Hero(
                        tag: 'displayPicture',
                        child: CircleAvatar(
                          backgroundImage: AssetImage('Assets/images/mum.JPG'),
                          backgroundColor: Color(0xFF008752),
                        ),
                      ),
                      onDetailsPressed: (){
                        _showProfile();
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.create),
                    title: Text('Sales Record'),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Available Drinks'),
                    onTap: (){
                      Navigator.pushNamed(context, Products.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_returned),
                    title: Text('Daily Reports'),
                    onTap: (){
                      Navigator.pushNamed(context, DailyReports.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_returned),
                    title: Text('Other Reports'),
                    onTap: (){
                      Navigator.pushNamed(context, OtherReports.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.note),
                    title: Text('Supply'),
                    onTap: (){
                      Navigator.pushNamed(context, SupplyPage.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    trailing: Switch(
                      activeColor: Color(0xFF008752),
                      value: _enabled,
                      onChanged: (bool value) {
                        if (!mounted) return;
                        setState(() {
                          _addThemeBoolToSF(value);
                          themeSwitch(context);
                        });
                      },
                    ),
                    title: Text('Theme'),
                    subtitle: _enabled ? Text('Dark Mode') : Text('Light Mode'),
                    onTap: (){
                    },
                  ),
                  ListTile(
                    title: Text('Sign Out'),
                    onTap: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 0.0,
                          child: Container(
                            height: 150.0,
                            padding: const EdgeInsets.all(16.0),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0),
                                    child: Text(
                                      "Are you sure you want to sign out",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 24.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // To close the dialog
                                        },
                                        textColor: Color(0xFF008752),
                                        child: Text('No'),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // To close the dialog
                                          _logout();
                                        },
                                        textColor: Color(0xFF008752),
                                        child: Text('Yes'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 1.0,
                  color: Colors.grey[400],
                ),
                FlatButton(
                  onPressed: (){
                    showAboutDialog(
                      context: context,
                      applicationName: 'Bizgenie Limited',
                      applicationIcon: AnimatedContainer(
                        width: 40.0,
                        height: 40.0,
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastOutSlowIn,
                        child: Image(
                          image: AssetImage('Assets/images/bizgenie_logo.png'),
                        ),
                      ),
                      applicationVersion: '1.0.0',
                      applicationLegalese: 'Developed by Farawe Taiwo Hassan',
                    );
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: RoundIconButton(
        icon: Icons.add,
        onPressed: _addRow
      )
    );
  }

  /// Using flutter toast to display a toast message [message]
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }

  /// Function to show profile of the account if the user is an Admin 'Farawe'
  void _showProfile(){
    if(_user == 'Admin'){
      Navigator.pushNamed(context, Profile.id);
    }else{
      Navigator.of(context).pop();
    }
  }

  /// Function to logout your account
  void _logout() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
    _getBoolValuesSF();
  }

  /// Function to get the 'loggedIn' in your SharedPreferences
  _getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('loggedIn') ?? true;
    if(boolValue == true){
      _addBoolToSF();
    }
  }

  /// Function to set the 'loggedIn' in your SharedPreferences to false
  _addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
  }

  /// Function to get the 'loggedIn' in your SharedPreferences
  _getThemeBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('themeMode');
    if(boolValue == true){
      if (!mounted) return;
      setState(() {
        _enabled = true;
      });
    }
    else if(boolValue == false){
      if (!mounted) return;
      setState(() {
        _enabled = false;
      });
    } else {
      _addThemeBoolToSF(false);
      if (!mounted) return;
      setState(() {
        _enabled = false;
      });
    }
  }

  /// Function to set the 'loggedIn' in your SharedPreferences to false
  _addThemeBoolToSF(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeMode', state);
    _getThemeBoolValuesSF();
  }

}
