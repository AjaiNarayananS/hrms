import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:hrms/auth/login.dart';
// import 'package:hrms/eventcalender/eventcalender.dart';
// import 'package:hrms/auth/login.dart';
import 'package:hrms/theme/theme.dart';
import 'package:hrms/theme/theme_manager.dart';
import 'package:provider/provider.dart';
// import 'package:hrms/timemangement/timemagement.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    

    return MaterialApp(
      title: 'HRMS',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      home: const Login(),
      // home: const CalendarHome(),
      // home: const TimeManagementHome(),

      builder: (context, child) => Stack(
        children: [
          if (child != null) child,
          const DropdownAlert(),
        ],
      ),
    );
  }
}
