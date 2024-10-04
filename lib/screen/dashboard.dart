import 'package:flutter/material.dart';
import 'package:hrms/components/attendancecard.dart';
import 'package:hrms/components/tilescard.dart';
import 'package:hrms/components/upcomingbirthday.dart';
import 'package:hrms/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.bing.com/th?id=OIP.jQvFuRlmVesA7K6ArjfyrAHaH9&w=150&h=161&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2'),
              radius: 25,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(fontSize: 12),
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
            icon: Icon(
                themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                  ),
                ),
              ),
            ),
            //Tiles Card
            const TilesCard(
              pendingCount: '5',
              requestCount: '3',
              totalCount: '20',
              availableCount: '12',
            ),
            // New Attendance Card
            const AttendanceCard(
              attendancePercentage: 40,
              percentageChange: 2.5,
              reportedCount: 10,
              onLeaveCount: 12,
              notReportedCount: 3,
            ),
            // Upcoming Birthdays Card
            UpcomingBirthdays(birthdays: [
              {
                'date': DateTime.now(),
                'name': 'John Doe',
                'role': 'Developer',
                'email': 'john.doe@example.com',
                'image':
                    'https://th.bing.com/th/id/OIP.Ta3GX6-k2iyMQt00doRnBQHaHa?w=195&h=195&c=7&r=0&o=5&dpr=1.3&pid=1.7',
              },
              {
                'date': DateTime(DateTime.now().year, 5, 15),
                'name': 'Jane Smith',
                'role': 'Designer',
                'email': 'jane.smith@example.com',
                'image':
                    'https://as2.ftcdn.net/v2/jpg/05/37/14/37/1000_F_537143711_P7tphHgMeVSuWPOMm1iskqoH2Tkx2NAG.jpg',
              },
              {
                'date': DateTime(DateTime.now().year, 6, 2),
                'name': 'Mike Johnson',
                'role': 'Manager',
                'email': 'mike.johnson@example.com',
                'image':
                    'https://as1.ftcdn.net/v2/jpg/05/77/46/78/1000_F_577467886_3hNFgtfq0o2r2dlsdBjHcsl6Ta3TLnSB.jpg',
              },
            ]),
          ],
        ),
      ),
    );
  }

 
}