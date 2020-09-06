import 'package:bizgienelimited/ui/navs/supplies/received_supply.dart';
import 'package:bizgienelimited/ui/navs/supplies/supply_in_progress.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'add_supply.dart';

class SupplyPage extends StatefulWidget {

  static const String id = 'supply_page';

  //final String payload;

  //const SupplyPage({Key key, this.payload}) : super(key: key);


  @override
  _SupplyPageState createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage> with SingleTickerProviderStateMixin {

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'In Progress'),
    Tab(text: 'Received'),
  ];

  final List<Widget> _children = [
    SupplyInProgress(),
    ReceivedSupply()
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Supplies", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 36.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, AddSupply.id);
                  },
                ),
              ],
            ),
          ],
        ),
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
