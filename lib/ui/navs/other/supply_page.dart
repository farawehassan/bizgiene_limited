import 'package:flutter/material.dart';

class SupplyPage extends StatefulWidget {

  static const String id = 'supply_page';

  @override
  _SupplyPageState createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
