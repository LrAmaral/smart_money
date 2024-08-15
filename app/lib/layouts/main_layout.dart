import 'package:flutter/material.dart';
import 'package:smart_money/pages/home_page.dart';
import 'package:smart_money/pages/goals_page.dart';
import 'package:smart_money/pages/profile_page.dart';
import 'package:smart_money/pages/transactions_page.dart';
import 'package:smart_money/utils/bottom_navbar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const TransactionsPage(),
    const GoalsPage(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
