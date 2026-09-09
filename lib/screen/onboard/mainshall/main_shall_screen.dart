import 'package:connectcall/screen/onboard/contact/contact_screen.dart';
import 'package:connectcall/screen/onboard/profile/profile_screen.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_buttomnav.dart'; 
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ContactsScreen(),
    CallsScreen(), 
    ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// 1. Home Screen (Index 0)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Home Dashboard',
          style: TextStyle(color: context.black),
        ),
        backgroundColor: context.white,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: context.primaryBlue, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 2. Calls Screen (Index 2 - Custom Bottom Nav ma 'Calls' vanera xa)
class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Calls Screen',
          style: TextStyle(color: context.black),
        ),
        backgroundColor: context.white,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Calls Screen (Grid)',
          style: TextStyle(color: context.primaryBlue, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}