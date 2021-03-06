import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A class to set constants for menu options in the profile page
class Constants{

  static const String Create = 'Create a worker';

  static const String ShowAll = 'All products';
  static const String ShowAvailable = 'Available products';
  static const String ShowFinished = 'Products out of stock';
  static const String ShowOther = 'Other products';

  static const String ShowUpdate = 'Update payment';
  static const String ShowSettle = 'Settle payment';

  static const String ShowMonthlyProductsSold = 'Products Sold';
  static const String ShowMonthlySupplies = 'Supplies';

  /// List of string to hold the menu options in [OutstandingBalance]
  static const List<String> showUpdateChoices = <String>[
    ShowUpdate,
    ShowSettle
  ];

  /// List of string to hold the menu options in [Products]
  static const List<String> showMonthChoices = <String>[
    ShowMonthlyProductsSold,
    ShowMonthlySupplies
  ];

  /// List of string to hold the menu options in [Products]
  static const List<String> showProductChoices = <String>[
    ShowAll,
    ShowAvailable,
    ShowFinished,
    ShowOther
  ];

  /// List of string to hold the menu options in [Profile]
  static const List<String> profileChoices = <String>[
    Create,
  ];

  /// List of String to hold all the 7up bottling company products
  static const List<String> sevenUpItems = [
    'Pepsi',
    '7up',
    'Mirinda Orange',
    'Mirinda Apple Red',
    'Mirinda Apple Green',
    'Teem Lemon',
    'Teem Soda',
    'Teem Tonic',
    'Lipton Ice Tea Peach',
    'Lipton Ice Tea Lemon',
    'H2oh',
    'Mountain Dew',
    'Aquafina Water 1.5 litres',
    'Aquafina Water 75cl',
    'Aquafina Water 50cl',
  ];

  /// Method to capitalize the first letter of each word in [string]
  static String capitalize(String string) {
    String result = '';

    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = new List();

      if(values.length == 1){
        result = string[0].toUpperCase() + string.substring(1);
      }
      else{
        for(int i = 0; i < values.length; i++){
          if(values[i].isNotEmpty){
            valuesToJoin.add(values[i][0].toUpperCase() + values[i].substring(1));
          }
        }
        result = valuesToJoin.join(' ');
      }

    }
    return result;
  }

  /// Convert a double [value] to naira
  static FlutterMoneyFormatter money(double value){
    FlutterMoneyFormatter val;
    val = FlutterMoneyFormatter(amount: value, settings: MoneyFormatterSettings(symbol: 'N'));
    return val;
  }

  /// Using FlutterToast to display toast message of value [message]
  static showMessage(String message){
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }

}

/// setting a constant [kTextFieldDecoration] for [InputDecoration] styles
const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF008752), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF008752), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

/// setting a constant [kAddProductDecoration] for [InputDecoration] styles
const kAddProductDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  //border: InputBorder.none,
);

/// Building a [Text] widget to display [title]
Text titleText(String title){
  return Text(
    title,
    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
  );
}

