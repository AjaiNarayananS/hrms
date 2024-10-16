import 'package:flutter/material.dart';
import 'package:hrms/eventcalender/agendaviewtab.dart';
import 'package:hrms/eventcalender/leavecalendertab.dart';
import 'package:hrms/eventcalender/schedulingtab.dart';

class CalendarHome extends StatelessWidget {
  const CalendarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: const Text(
            'Event Calendar',
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
              Tab(icon: Icon(Icons.schedule), text: 'Scheduling'),
              Tab(icon: Icon(Icons.calendar_today), text: 'Month Agenda'),
              Tab(icon: Icon(Icons.business_center), text: 'Leave'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SchedulingTab(),
            MonthAgendaTab(),
            LeaveTab(),
          ],
        ),
      ),
    );
  }
}
