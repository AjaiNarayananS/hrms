import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/components/attendancecard.dart';
import 'package:hrms/components/tilescard.dart';
import 'package:hrms/components/upcomingbirthday.dart';
import 'package:hrms/main.dart';
import 'package:hrms/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DateTime> _selectedDates = [];
  List<Map<String, dynamic>> upcomingBirthdays = [];
  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);
    final userData = userDetailsProvider.userDetails;

    // Convert the API data to TileData objects
    List<TileData> tiles = (userData?['tiles'] as List<dynamic>?)?.map((tile) {
      return TileData(
        title: tile['title'],
        value: tile['value'],
        color: _getColorFromString(tile['color']),
        icon: _getIconFromString(tile['icon']),
      );
    }).toList() ?? [];
    
    upcomingBirthdays = (userData?['upcomingBirthdays'] as List<dynamic>?)
        ?.map((birthday) => birthday as Map<String, dynamic>)
        .toList() ?? [];

    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userData?['avatar'] ?? ''),
                  radius: 25,
                ),
                const SizedBox(width: 15),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userData?['name'] ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userData?['email'] ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: Theme.of(context).secondaryHeaderColor,
                onPressed: () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(100, 50, 0, 0),
                    items: [
                      const PopupMenuItem(child: Text('Notification 1')),
                      const PopupMenuItem(child: Text('Notification 2')),
                      const PopupMenuItem(child: Text('Notification 3')),
                    ],
                  );
                },
              ),
              IconButton(
                icon: Icon(themeManager.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: () {
                  themeManager.toggleTheme();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name, email or phone number',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/home/dashboard/service');
                          },
                          icon: const Icon(
                            Icons.build,
                            color: Colors.white,
                          ),
                          label: const Text('Service Request',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showLeaveDatePicker(context),
                          icon:
                              const Icon(Icons.event_busy, color: Colors.white),
                          label: const Text('Leave Request',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                //Tiles Card
                TilesCard(tiles: tiles),
                // Updated Attendance Card
                AttendanceCard(
                  attendancePercentage: (userData?['attendance']?['percentage'] as num?)?.toDouble() ?? 0.0,
                  percentageChange: (userData?['attendance']?['percentageChange'] as num?)?.toDouble() ?? 0.0,
                  reportedCount: userData?['attendance']?['reportedCount'] as int? ?? 0,
                  onLeaveCount: userData?['attendance']?['onLeaveCount'] as int? ?? 0,
                  notReportedCount: userData?['attendance']?['notReportedCount'] as int? ?? 0,
                ),
                // Updated Upcoming Birthdays Card
                UpcomingBirthdays(
                  birthdays: upcomingBirthdays.map((birthday) => {
                    'date': DateTime.parse(birthday['date']),
                    'name': birthday['name'],
                    'role': birthday['role'],
                    'email': birthday['email'],
                    'image': birthday['image'],
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to convert string color to Colors object
  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey; // Default color if not recognized
    }
  }

  // Helper method to convert string icon name to IconData
  IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'check_circle':
        return Icons.check_circle;
      case 'cancel':
        return Icons.cancel;
      case 'block':
        return Icons.block;
      default:
        return Icons.error; // Default icon if not recognized
    }
  }

  void _showLeaveDatePicker(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = initialDate;
    final lastDate = initialDate.add(const Duration(days: 365));

    final DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: DateTimeRange(start: initialDate, end: initialDate),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (dateTimeRange != null) {
      setState(() {
        if (dateTimeRange.start == dateTimeRange.end) {
          // Single date selected
          _selectedDates = [dateTimeRange.start];
        } else {
          // Multiple dates selected
          _selectedDates = List.generate(
            dateTimeRange.end.difference(dateTimeRange.start).inDays + 1,
            (index) => dateTimeRange.start.add(Duration(days: index)),
          );
        }
      });

      if (context.mounted && _selectedDates.isNotEmpty) {
        _showLeaveRequestConfirmation(context);
      }
    }
  }

  void _showLeaveRequestConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm Leave Request',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Selected dates:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    itemCount: _selectedDates.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.calendar_today,
                            color: Theme.of(context).primaryColor),
                        title: Text(
                          DateFormat('EEEE, MMMM d, yyyy')
                              .format(_selectedDates[index]),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement leave request submission
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Leave request submitted successfully')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Submit Request',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}