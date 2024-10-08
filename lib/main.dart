import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:hrms/auth/login.dart';
import 'package:hrms/screen/service.dart';
import 'package:hrms/theme/theme.dart';
import 'package:hrms/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/navigation/navigation.dart';
import 'package:hrms/screen/dashboard.dart';
import 'package:hrms/screen/employelist.dart';
import 'package:hrms/screen/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Add this new class to manage user details
class UserDetailsProvider extends ChangeNotifier {
  Map<String, dynamic>? _userDetails;

  Map<String, dynamic>? get userDetails => _userDetails;

  Future<void> fetchUserDetails() async {
    final response = await http.get(Uri.parse('https://6704b4e6ab8a8f8927348c50.mockapi.io/hrms/api/v1/my_details'));
    if (response.statusCode == 200) {
      _userDetails = json.decode(response.body)[0];
      notifyListeners();
    } else {
      throw Exception('Failed to load user details');
    }
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Login(),
        ),
        ShellRoute(
          builder: (context, state, child) => HomePage(child: child),
          routes: [
            GoRoute(
              path: '/home/dashboard',
              builder: (context, state) => const DashboardScreen(),
              routes: [
                GoRoute(
                  path: 'service',
                  builder: (context, state) => const ServiceScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/home/assessment',
              builder: (context, state) => const Placeholder(), 
            ),
            GoRoute(
              path: '/home/employee-list',
              builder: (context, state) => const EmployeeListScreen(),
            ),
            GoRoute(
              path: '/home/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );

    // Fetch user details when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserDetailsProvider>(context, listen: false).fetchUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp.router(
          title: 'HRMS',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeManager.themeMode,
          routerConfig: _router,
          builder: (context, child) => Stack(
            children: [
              if (child != null) child,
              const DropdownAlert(),
            ],
          ),
        );
      },
    );
  }
}

