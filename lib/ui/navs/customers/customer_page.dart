import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'all_customers.dart';
import 'outstanding_balance_customers.dart';

/// A stateful widget class to display tabs for both [OutstandingBalance] and
/// [AllCustomers]
class CustomerPage extends StatefulWidget {

  static const String id = 'customer_page';

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> with SingleTickerProviderStateMixin {

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Outstanding Balance'),
    Tab(text: 'All Customers'),
  ];

  final List<Widget> _children = [
    OutstandingBalance(),
    AllCustomers(),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Customers", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 36.0),),
        backgroundColorStart: Color(0xFF004C7F),
        backgroundColorEnd: Color(0xFF008752),
        elevation: 0.0,
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.transparent,
          labelColor: Colors.white,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          return _children[myTabs.indexOf(tab)];
        }).toList(),
      ),
    );
  }

}
