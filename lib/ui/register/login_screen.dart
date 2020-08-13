import 'package:bizgienelimited/database/user_db_helper.dart';
import 'package:bizgienelimited/model/user.dart';
import 'package:bizgienelimited/styles/theme.dart' as Theme;
import 'package:bizgienelimited/ui/navs/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'login_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bizgienelimited/utils/size_config.dart';

/// A StatefulWidget class that displays the login screen of the app
class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin
    implements LoginScreenContract {

  /// A [GlobalKey] to hold the Scaffold state of my build widget
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// A [GlobalKey] to hold the form state of my form widget for form validation
  final _formKey = GlobalKey<FormState>();

  /// An variable to hold an instance of [LoginScreenPresenter]
  LoginScreenPresenter _presenter;

  /// Instantiating the [LoginScreenPresenter] class to handle the login requests
  _LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
  }

  /// Creating [FocusNode] for login details
  final FocusNode myFocusNodePhoneLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  /// A [TextEditingController] to control the input text for the user's number
  TextEditingController loginPhoneController = new TextEditingController();

  /// A [TextEditingController] to control the input text for the user's password
  TextEditingController loginPasswordController = new TextEditingController();

  /// A string variable to hold the user's number
  String _phoneNumber;

  /// A string variable to hold the user's pin
  String _pin;

  /// A boolean variable to hold the [inAsyncCall] value in my
  /// [ModalProgressHUD] widget
  bool _showSpinner = false;

  /// A boolean variable to hold whether the password should be shown or hidden
  bool _obscureTextLogin = true;

  Color left = Colors.black;
  Color right = Colors.white;

  double _animatedHeight = 190;
  double _loginMargin = 170;

  /// Setting device orientation to portraitUp or portraitDown only for this page
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004C7F)),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight >= 775.0
                ? SizeConfig.screenHeight
                : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.ColorGradients.loginGradientStart,
                    Theme.ColorGradients.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'BIZGENIE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'LIMITED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: new Image(
                      width: 250.0,
                      height: 191.0,
                      fit: BoxFit.fill,
                      image: new AssetImage('Assets/images/login_logo.png')),
                ),
                Container(
                  child: _buildSignIn(context),
                ),
                /*Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "3, Fawehinmi street Off Ojuelegba Road Surulere Lagos",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// My [FocusNode] used with [SingleTickerProviderStateMixin] is disposed here
  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodePhone.dispose();
    myFocusNodeName.dispose();
    super.dispose();
  }

  /// Function to display a snackbar with the value [value]
  void _showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: Color(0xFF008752),
      duration: Duration(seconds: 4),
    ));
  }

  /// A function to return a container for the login information
  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: AnimatedContainer(
                    width: 300.0,
                    height: _animatedHeight,
                    duration: Duration(seconds: 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePhoneLogin,
                            controller: loginPhoneController,
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _animatedHeight = 230;
                                  _loginMargin = 200;
                                });
                                return 'Enter a phone number';
                              }
                              setState(() {
                                _animatedHeight = 190;
                                _loginMargin = 170;
                              });
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black
                            ),
                            onChanged: (value){
                              _phoneNumber = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.phone,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                fontSize: 17.0,
                                color: Colors.black54
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _animatedHeight = 230;
                                  _loginMargin = 210;
                                });
                                return 'Enter a pin';
                              }
                              setState(() {
                                _animatedHeight = 200;
                                _loginMargin = 170;
                              });
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Pin",
                              hintStyle: TextStyle(
                                fontSize: 17.0,
                                color: Colors.black54
                              ),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextLogin
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onChanged: (value){
                              _pin = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _loginMargin),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.ColorGradients.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.ColorGradients.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Theme.ColorGradients.loginGradientEnd,
                        Theme.ColorGradients.loginGradientStart
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
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        _submit();
                      }
                    }
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
              onPressed: () {

              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    " ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A function to toggle if to show the password or not by
  /// changing [_obscureTextLogin] value
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  /// A function to do the login process by calling the [doLogin] function in
  /// the [LoginScreenPresenter] class with the [_phoneNumber] and [_pin]
  void _submit() {
    setState(() => _showSpinner = true);
    _presenter.doLogin(_phoneNumber, _pin);
  }

  /// This function adds a true boolean value to the device [SharedPreferences]
  /// and clears both [loginPhoneController] and [loginPasswordController] controllers
  addBoolToSF(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', state);
    if (state == true){
      Navigator.of(context).pushReplacementNamed(MyHomePage.id);
    }
    loginPhoneController.clear();
    loginPasswordController.clear();
  }

  /// This function calls [_showInSnackBar()] to show a snackbar
  /// with details [errorTxt], then sets [_showSpinner] to false to stop syncing
  /// [ModalProgressHUD] and clears the [loginPasswordController] controller
  @override
  void onLoginError(String errorTxt) {
    _showInSnackBar(errorTxt);
    setState(() => _showSpinner = false);
    loginPasswordController.clear();
  }

  /// This function calls [_showInSnackBar()] to show a snackbar with Login
  /// Successfully as its details, then sets [_showSpinner] to false
  /// to stop syncing [ModalProgressHUD] and
  /// clears both [loginPhoneController] and [loginPasswordController] controllers
  /// It also saves the user's details in the database with the help of [DatabaseHelper]
  @override
  void onLoginSuccess(User user) async {
    _showInSnackBar('Login Successfully');
    setState(() => _showSpinner = false);
    loginPhoneController.clear();
    loginPasswordController.clear();
    var db = new DatabaseHelper();
    await db.saveUser(user);
    addBoolToSF(true);
  }

}
