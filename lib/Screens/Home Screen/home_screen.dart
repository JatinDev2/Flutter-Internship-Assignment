import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:quantmhill_assignment/App%20Constants/ColorsManager.dart';
import 'package:quantmhill_assignment/Screens/Employee%20Screens/add_new_employee.dart';
import 'package:quantmhill_assignment/Screens/Employee%20Screens/show_employees.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const EmployeeDetailsPage(),
   const EmployeeCreatePage(),
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
      bottomNavigationBar: GNav(
        rippleColor: ColorsManager.primaryGreen.withOpacity(0.1),
        hoverColor: ColorsManager.primaryGreen.withOpacity(0.1),
        haptic: true,
        tabBorderRadius: 20,
        tabActiveBorder: Border.all(color: ColorsManager.primaryGreen, width: 1),
        tabBorder: Border.all(color: Colors.transparent, width: 1),
        tabShadow: [BoxShadow(color: Colors.teal.withOpacity(0.2), blurRadius: 8)],
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 500),
        gap: 10,
        color: ColorsManager.grey400,
        activeColor: Colors.white,
        iconSize: 30,
        tabBackgroundColor: ColorsManager.primaryGreen.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
        backgroundColor: ColorsManager.primaryGreen,
        tabs: const [
          GButton(
            icon: LineIcons.home,
            text: 'Home',
          ),
          GButton(
            icon: LineIcons.userPlus,
            text: 'Add Employee',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      )

    );
  }
}
