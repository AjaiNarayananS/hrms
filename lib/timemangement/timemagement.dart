import 'package:flutter/material.dart';
import 'package:hrms/timemangement/timesheet.dart';
import 'package:hrms/timemangement/clientssheet.dart';
import 'package:hrms/timemangement/projectcreate.dart';

class TimeManagementHome extends StatelessWidget {
  const TimeManagementHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: const Text(
            'Time Management',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: TabBar(
            indicatorColor: Theme.of(context).secondaryHeaderColor,
            labelColor: Theme.of(context).highlightColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.access_time), text: 'Timesheet'),
              Tab(icon: Icon(Icons.people), text: 'Clients'),
              Tab(icon: Icon(Icons.work), text: 'Projects'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TimesheetCalendar(),
            ClientsSheet(),
            ProjectCreate(),
          ],
        ),
      ),
    );
  }
}
