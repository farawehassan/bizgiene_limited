import 'dart:async';
import 'package:bizgienelimited/ui/welcome_screen.dart';
import 'package:flutter/material.dart';

/// A StatefulWidget class to show the splash screen of my application
class Splash extends StatefulWidget {

  static const String id = 'splash_screen_page';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  /// Calling [navigate()] before the page loads
  @override
  void initState() {
    super.initState();
    navigate();
  }

  /// A function to set a 3 seconds timer for my splash screen to show
  /// and navigate to my [welcome] screen after
  void navigate(){
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: (){},
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.loose,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                child: Image.asset('Assets/images/bizgenie_splash.png'),
                              ),
                              radius: 200,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF008752)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}