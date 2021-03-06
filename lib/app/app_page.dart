import 'package:ez_charge/app/design/design.dart';
import 'package:ez_charge/app/design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'invoices.dart';
import 'settings.dart';
import 'charging_map.dart';

/// This is the stateful widget that the main application instantiates.
class AppPage extends StatefulWidget {
  AppPage({Key key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}
/// This is the private State class that goes with the AppPage class.
class _AppPageState extends State<AppPage> {

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    Invoices(),
    ChargingMap(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Charging Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: theme.bottomAppBarColor,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}