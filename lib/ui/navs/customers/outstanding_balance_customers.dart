import 'package:bizgienelimited/utils/reusable_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutstandingBalance extends StatefulWidget {

  static const String id = 'outstanding_balance_customers_page';

  @override
  _OutstandingBalanceState createState() => _OutstandingBalanceState();
}

class _OutstandingBalanceState extends State<OutstandingBalance> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          margin: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 10.0, left: 12.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Mr Farawe Taiwo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){},
                            child: Icon(
                              Icons.update,
                              color: Colors.grey[500],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){},
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.grey[500],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, left: 12.0,),
                        child: Text(
                          "Balance - N5,000",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: 2,
                        child: Text(''),
                        color: Colors.grey,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, right: 12.0,),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){},
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.grey[500],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "Tue, 13 Jul",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
