import 'package:bizgienelimited/bloc/future_values.dart';
import 'package:bizgienelimited/model/customerDB.dart';
import 'package:bizgienelimited/model/customer_reports.dart';
import 'package:bizgienelimited/model/supply_details.dart';
import 'package:bizgienelimited/ui/navs/supplies/supply_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:bizgienelimited/main.dart';
import 'dart:io' show Platform;

class NotificationManager {

  var flutterLocalNotificationsPlugin;

  /// Instantiating a class of the [FutureValues]
  var futureValue = FutureValues();

  NotificationManager() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS ){
      requestIOSPermissions();
    }
    initNotifications();
  }

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Converting [dateTime] in string format to return a formatted time
  /// of weekday, month, day and year
  String _getFormattedTime(String dateTime) {
    return DateFormat('MMM d, ''yyyy').format(DateTime.parse(dateTime)).toString();
  }

  Future configureSupplyNotifications() async {
    Future<List<Supply>> supplies = futureValue.getInProgressSuppliesFromDB();
    await supplies.then((value) {
      print(value);
      if(value.length != 0){
        print(value.length);
        for (int i = 0; i < value.length; i++){
          var paymentDate = DateTime.parse(value[i].createdAt);
          var now = DateTime.now();
          var difference = now.difference(paymentDate).inDays;
          if(value[i].received == false && difference >= 2){
            showSupplyNotificationDaily(0, "Supply", "Your supply payed on "
                "${_getFormattedTime(value[i].createdAt)} is yet to be received."
                "If received, kindly come back and update your supply",
                DateTime.now().hour,
                DateTime.now().minute
            );
          }
        }
      }
    }).catchError((error){
      print(error);
      //Constants.showMessage(error.toString());
    });
  }

  Future configureCustomerNotifications() async {
    Future<Map<CustomerReport, Customer>> customers = futureValue.getCustomersWithOutstandingBalance();
    await customers.then((value) {
      print(value);
      if(value.length != 0) {
        //List<Customer> customer = value.values;
        List<CustomerReport> customerReport = value.keys.toList();
        var now = DateTime.now().day;
        var dueDate;
        for (int j = 0; j < customerReport.length; j++) {
          if (customerReport[j].paid == false) {
            dueDate = DateTime.parse(customerReport[j].dueDate).day;
            var difference = now - dueDate;
            if (difference >= 0) {
              print("Customer = $difference" );
              showCustomerNotificationDaily(
                  0, "Customer", "You have customers "
                  "yet to settle his/her payment."
                  "If settled, kindly come back and update your customer\'s payment",
                  DateTime.now().hour,
                  DateTime.now().minute
              );
            }
          }
        }
      }
    }).catchError((error){
      print(error);
    });
  }

  void initNotifications() async {
    /// initialise the plugin.
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future showCustomerNotificationDaily(
      int id, String title, String body, int hour, int minute) async {
    var time = new Time(hour, minute, 0);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, getCustomerPlatformChannelSpecifics(id), payload: 'customer payload');
    print('Notification Successfully Scheduled at ${time.toString()} with id of $id');
  }

  Future showSupplyNotificationDaily(
      int id, String title, String body, int hour, int minute) async {
    var time = new Time(hour, minute, 0);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, getSupplyPlatformChannelSpecifics(id), payload: 'supply payload');
    print('Notification Successfully Scheduled at ${time.toString()} with id of $id');
  }

  getSupplyPlatformChannelSpecifics(int id) {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '$id',
        'Supply notifications ',
        'Notifications for supplies not yet received',
        importance: Importance.Max,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(''),
        channelShowBadge: true,
        priority: Priority.High,
        ticker: 'Notification Reminder');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }

  getCustomerPlatformChannelSpecifics(int id) {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '$id',
        'Customer notifications ',
        'Notifications for customers passing their due date',
        importance: Importance.Max,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(''),
        channelShowBadge: true,
        priority: Priority.High,
        ticker: 'Notification Reminder');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: MyApp.navigatorKey.currentContext,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              if(payload == 'supply payload'){
                print('notification payload: ' + payload);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupplyPage()),
                );
              }
              else if(payload == 'customer payload'){
                print('notification payload: ' + payload);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupplyPage()),
                );
              }
            },
          )
        ],
      ),
    );
    //return Future.value(1);
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    if (payload == null || payload.trim().isEmpty) {
      debugPrint('notification payload: ' + payload);
    }
    else if(payload == 'supply payload'){
      print('notification payload: ' + payload);
      await Navigator.push(
        MyApp.navigatorKey.currentContext,
        MaterialPageRoute(builder: (context) => SupplyPage()),
      );
    }
    else if(payload == 'customer payload'){
      print('notification payload: ' + payload);
      await Navigator.push(
        MyApp.navigatorKey.currentContext,
        MaterialPageRoute(builder: (context) => SupplyPage()),
      );
    }
  }

  void removeReminder(String notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
    print('Notification with id: $notificationId been removed successfully');
  }

}