import 'package:bizgienelimited/ui/register/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navs/home_page.dart';

/// A StatefulWidget class that checks whether a user is logged in
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    getBoolValuesSF();
    return Container();
  }

  /// This function that checks whether a user is logged in with
  /// a [SharedPreferences] value of bool
  /// It navigates to [MyHomePage] if the value is true and [LoginScreen]
  /// if the value is false
  void getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('loggedIn');
    if(boolValue == true){
      Navigator.of(context).pushReplacementNamed(MyHomePage.id);
    }
    else if(boolValue == false){
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    }
    else {
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    }

  }

}


