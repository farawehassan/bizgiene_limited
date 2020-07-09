import 'package:flutter/material.dart';

class CreateSupply extends StatefulWidget {

  static const String id = 'create_supply_page';

  @override
  _CreateSupplyState createState() => _CreateSupplyState();
}

class _CreateSupplyState extends State<CreateSupply> {

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
