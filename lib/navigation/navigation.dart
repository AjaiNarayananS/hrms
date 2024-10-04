import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hrms/screen/dashboard.dart';
import 'package:hrms/screen/employelist.dart';
import 'package:hrms/screen/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AssessmentScreen(),
    const EmployeeListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: theme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
          child: GNav(
            gap: 8,
            activeColor: theme.secondaryHeaderColor,
            color: theme.colorScheme.onPrimary.withOpacity(0.6),
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: theme.focusColor,
            tabs: [
              GButton(icon: Icons.home, text: 'Dashboard', textStyle: theme.textTheme.labelLarge),
              GButton(icon: Icons.assessment, text: 'Assessment', textStyle: theme.textTheme.labelLarge),
              GButton(icon: Icons.groups, text: 'Employee List', textStyle: theme.textTheme.labelLarge),
              GButton(icon: Icons.face, text: 'Profile', textStyle: theme.textTheme.labelLarge),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}



class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Assessment'));
  }
}



