  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:google_fonts/google_fonts.dart';

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
            height: 120,
            margin: const EdgeInsets.all(10.0),
            child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 69.25,
                    padding: const EdgeInsets.only(top: 10.0, left: 12.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.solidFile,
                                ),
                                onPressed: (){},
                                color: Color(0xFF008752),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green[50]
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Mr Farawe Taiwo",
                                    style: GoogleFonts.mcLaren(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Lorem ipsum snmsvb",
                                    style: GoogleFonts.mcLaren(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){},
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey[500],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1.5,
                    color: Colors.grey[500],
                  ),
                  Container(
                    height: 49.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0, left: 12.0,),
                            child: Text(
                              "Balance - N5,000",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 49.25,
                          child: Text(''),
                          color: Colors.grey,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0, right: 12.0,),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){},
                                  child: Icon(
                                    FontAwesomeIcons.calendarAlt,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Tue, 13 Jul",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
