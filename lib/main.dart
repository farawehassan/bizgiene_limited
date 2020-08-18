import 'dart:io';
import 'package:bizgienelimited/ui/navs/customers/customer_page.dart';
import 'package:bizgienelimited/ui/navs/daily/daily_report_list.dart';
import 'package:bizgienelimited/ui/navs/daily/daily_reports.dart';
import 'package:bizgienelimited/ui/navs/home_page.dart';
import 'package:bizgienelimited/ui/navs/monthly/reports_page.dart';
import 'package:bizgienelimited/ui/navs/products_sold.dart';
import 'package:bizgienelimited/ui/navs/supplies/add_supply.dart';
import 'package:bizgienelimited/ui/navs/supplies/supply_page.dart';
import 'package:bizgienelimited/ui/profile_page.dart';
import 'package:bizgienelimited/ui/register/create_worker.dart';
import 'package:bizgienelimited/ui/register/login_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ui/navs/available_drinks.dart';
import 'ui/splash.dart';
import 'ui/welcome_screen.dart';

/// Enabling platform override for desktop
void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

/// Function to call my main application [MyApp()]
/// and [enablePlatformOverrideForDesktop()]
void main() {
  enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

/// A StatelessWidget class to hold basic details and routes of my application
class MyApp extends StatefulWidget {

  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              brightness: brightness,
              cursorColor: Color(0xFF008752),
              primaryColor: Color(0xFF004C7F),
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Bizgenie Limited',
            debugShowCheckedModeBanner: false,
            theme: theme,
            initialRoute: Splash.id,
            routes: {
              Splash.id: (context) => Splash(),
              LoginScreen.id: (context) => LoginScreen(),
              WelcomeScreen.id: (context) => WelcomeScreen(),
              MyHomePage.id: (context) => MyHomePage(),
              Products.id: (context) => Products(),
              DailyReports.id: (context) => DailyReports(),
              DailyReportList.id: (context) => DailyReportList(),
              Profile.id: (context) => Profile(),
              CreateWorker.id: (context) => CreateWorker(),
              ReportPage.id: (context) => ReportPage(),
              ProductsSold.id: (context) => ProductsSold(),
              SupplyPage.id: (context) => SupplyPage(),
              AddSupply.id: (context) => AddSupply(),
              CustomerPage.id: (context) => CustomerPage(),
            },
          );
        });
  }
}
