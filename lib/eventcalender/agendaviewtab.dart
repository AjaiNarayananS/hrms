import 'dart:convert'; // Import the dart:convert library
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

const String jsonString = '''{
      "events": [
        {
          "date": "2024-10-01",
          "events": [
            {
              "eventName": "Team Meeting",
              "from": "2024-10-01T09:00:00",
              "to": "2024-10-01T10:00:00",
              "background": "#FF5733",
              "details": "Monthly team meeting to discuss project updates."
            },
            {
              "eventName": "Client Call",
              "from": "2024-10-01T14:00:00",
              "to": "2024-10-01T15:00:00",
              "background": "#33FF57",
              "details": "Call with the client to review requirements."
            }
          ]
        },
        {
          "date": "2024-10-02",
          "events": [
            {
              "eventName": "Project Planning",
              "from": "2024-10-02T11:00:00",
              "to": "2024-10-02T12:30:00",
              "background": "#3357FF",
              "details": "Planning meeting for the upcoming project."
            }
          ]
        },
        {
          "date": "2024-10-03",
          "events": [
            {
              "eventName": "Development Sprint",
              "from": "2024-10-03T10:00:00",
              "to": "2024-10-03T16:00:00",
              "background": "#FFC300",
              "details": "Start of the new development sprint."
            },
            {
              "eventName": "Team Lunch",
              "from": "2024-10-03T13:00:00",
              "to": "2024-10-03T14:00:00",
              "background": "#FF5733",
              "details": "Team lunch to celebrate project milestones."
            }
          ]
        },
        {
          "date": "2024-10-04",
          "events": [
            {
              "eventName": "Code Review",
              "from": "2024-10-04T10:00:00",
              "to": "2024-10-04T11:30:00",
              "background": "#33FF57",
              "details": "Review code for the last sprint."
            }
          ]
        },
        {
          "date": "2024-10-05",
          "events": [
            {
              "eventName": "Release Planning",
              "from": "2024-10-05T09:00:00",
              "to": "2024-10-05T10:30:00",
              "background": "#3357FF",
              "details": "Planning for the upcoming release."
            },
            {
              "eventName": "Retrospective Meeting",
              "from": "2024-10-05T14:00:00",
              "to": "2024-10-05T15:00:00",
              "background": "#FFC300",
              "details": "Discuss what went well and what can be improved."
            }
          ]
        }
      ]
    }''';

class MonthAgendaTab extends StatefulWidget {
  const MonthAgendaTab({super.key});

  @override
  _MonthAgendaTabState createState() => _MonthAgendaTabState();
}

class _MonthAgendaTabState extends State<MonthAgendaTab> {
  late _MeetingDataSource _events;
  final CalendarController _calendarController = CalendarController();
  List<_Meeting>? _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController.selectedDate = DateTime.now();
    _events = _MeetingDataSource(_getAppointments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SfCalendar(
              todayHighlightColor: Theme.of(context).secondaryHeaderColor,
              view: CalendarView.month,
              controller: _calendarController,
              monthViewSettings: const MonthViewSettings(
                showAgenda: false,
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              ),
              dataSource: _events,
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell &&
                    details.date != null) {
                  DateTime tappedDate = details.date!;
                  _updateEventDetailsOnDate(tappedDate);
                } else {
                  _clearEventDetails();
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              // color: Colors.white,
              child: _selectedEvents != null && _selectedEvents!.isNotEmpty
                  ? _buildEventDetails()
                  : _buildNoEventSelected(),
            ),
          ),
        ],
      ),
    );
  }

  void _updateEventDetailsOnDate(DateTime date) {
    _selectedEvents = _events.source.where((event) {
      return event.from.day == date.day &&
          event.from.month == date.month &&
          event.from.year == date.year;
    }).toList();

    setState(() {});
  }

  void _clearEventDetails() {
    setState(() {
      _selectedEvents = null;
    });
  }

  Widget _buildEventDetails() {
    return ListView.builder(
      itemCount: _selectedEvents!.length,
      itemBuilder: (context, index) {
        final event = _selectedEvents![index];
        return Card(
          color: event.background,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(
              event.eventName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(
              'Time: ${event.from.hour}:00 - ${event.to.hour}:00\n'
              '${event.details}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoEventSelected() {
    return const Center(
      child: Text(
        'No events available for the selected date',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  /// Generates a list of appointments for the calendar.
  List<_Meeting> _getAppointments() {
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    List<_Meeting> meetings = [];

    for (var eventDay in jsonData['events']) {
      String dateStr = eventDay['date'];
      DateTime.parse(dateStr);
      for (var event in eventDay['events']) {
        meetings.add(_Meeting(
          event['eventName'],
          DateTime.parse(event['from']),
          DateTime.parse(event['to']),
          Color(int.parse(
              "0xFF${event['background'].substring(1)}")), // Fix color parsing
          details: event['details'],
        ));
      }
    }

    return meetings;
  }
}

class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, {this.details});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String? details;
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

  @override
  List<_Meeting> get appointments => source;

  @override
  DateTime getStartTime(int index) => source[index].from;

  @override
  DateTime getEndTime(int index) => source[index].to;

  @override
  Color getColor(int index) => source[index].background;

  @override
  String getSubject(int index) => source[index].eventName;

  @override
  bool isAllDay(int index) => false;
}
