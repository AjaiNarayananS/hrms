// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
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

class SchedulingTab extends StatefulWidget {
  const SchedulingTab({super.key});

  @override
  _SchedulingTabState createState() => _SchedulingTabState();
}

class _SchedulingTabState extends State<SchedulingTab> {
  final List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    // Load events from JSON data
    _appointments.addAll(_parseJsonData(jsonString));
  }

  List<Appointment> _parseJsonData(String jsonData) {
    final Map<String, dynamic> parsedData = json.decode(jsonData);
    List<Appointment> appointments = [];

    for (var event in parsedData['events']) {
      for (var e in event['events']) {
        appointments.add(Appointment(
          subject: e['eventName'],
          startTime: DateTime.parse(e['from']),
          endTime: DateTime.parse(e['to']),
          color: _getColorFromHex(e['background']),
          notes: e['details'],
        ));
      }
    }

    return appointments;
  }

  Color _getColorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('0xff$hexCode'));
  }

  void _addAppointment(Appointment appointment) {
    setState(() {
      _appointments.add(appointment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MonthViewScreen(
        appointments: _appointments,
        onAppointmentAdded: _addAppointment,
      ),
    );
  }
}

class MonthViewScreen extends StatelessWidget {
  final List<Appointment> appointments;
  final Function(Appointment) onAppointmentAdded;

  const MonthViewScreen({
    super.key,
    required this.appointments,
    required this.onAppointmentAdded,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      todayHighlightColor: Theme.of(context).secondaryHeaderColor,
      view: CalendarView.month,
      dataSource: MeetingDataSource(appointments),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell &&
            details.date != null) {
          // Navigate to Day View with the selected date
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DayViewScreen(
                initialDisplayDate: details.date!,
                initialSelectedDate: details.date!,
                appointments: appointments.where((appointment) {
                  return appointment.startTime.year == details.date!.year &&
                      appointment.startTime.month == details.date!.month &&
                      appointment.startTime.day == details.date!.day;
                }).toList(),
                onAppointmentAdded: onAppointmentAdded,
              ),
            ),
          );
        }
      },
    );
  }
}

class DayViewScreen extends StatefulWidget {
  final DateTime initialDisplayDate;
  final DateTime initialSelectedDate;
  final List<Appointment> appointments;
  final Function(Appointment) onAppointmentAdded;

  const DayViewScreen({
    super.key,
    required this.initialDisplayDate,
    required this.initialSelectedDate,
    required this.appointments,
    required this.onAppointmentAdded,
  });

  @override
  _DayViewScreenState createState() => _DayViewScreenState();
}

class _DayViewScreenState extends State<DayViewScreen> {
  late DateTime selectedDate;
  late List<Appointment> currentAppointments;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialSelectedDate;
    currentAppointments = widget.appointments;
  }

  void _addEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(
          onEventAdded: (appointment) {
            setState(() {
              currentAppointments.add(appointment);
              widget.onAppointmentAdded(appointment);
            });
          },
          selectedDate: selectedDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addEvent(context);
            },
          ),
        ],
      ),
      body: SfCalendar(
        todayHighlightColor: Theme.of(context).secondaryHeaderColor,
        view: CalendarView.day,
        initialDisplayDate: widget.initialDisplayDate,
        dataSource: MeetingDataSource(currentAppointments),
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 8,
          endHour: 21,
          timeIntervalHeight: -1,
          timeTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell &&
              details.date != null) {
            selectedDate = details.date!;
            _addEvent(context);
          }
        },
      ),
    );
  }
}

class AddEventScreen extends StatefulWidget {
  final Function(Appointment) onEventAdded;
  final DateTime? selectedDate;

  const AddEventScreen({
    super.key,
    required this.onEventAdded,
    this.selectedDate,
  });

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  String title = '';
  String description = '';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 1));
  Color selectedColor = Colors.blue;

  final List<Map<String, dynamic>> colors = [
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Yellow', 'color': Colors.yellow},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      startTime = widget.selectedDate!;
      endTime = startTime.add(const Duration(hours: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              if (title.isNotEmpty) {
                final appointment = Appointment(
                  startTime: startTime,
                  endTime: endTime,
                  subject: title,
                  notes: description,
                  color: selectedColor,
                );
                widget.onEventAdded(appointment);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Add Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 16),
              _buildColorDropdown(),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  description = value;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildDateTimeRow(
                context,
                label: 'Start',
                dateTime: startTime,
                onDateChanged: (DateTime newDateTime) {
                  setState(() {
                    startTime = newDateTime;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDateTimeRow(
                context,
                label: 'End',
                dateTime: endTime,
                onDateChanged: (DateTime newDateTime) {
                  setState(() {
                    endTime = newDateTime;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorDropdown() {
    return DropdownButton<Map<String, dynamic>>(
      value:
          colors.firstWhere((colorMap) => colorMap['color'] == selectedColor),
      isExpanded: true,
      onChanged: (Map<String, dynamic>? newValue) {
        setState(() {
          selectedColor = newValue!['color'];
        });
      },
      items: colors.map<DropdownMenuItem<Map<String, dynamic>>>((colorMap) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: colorMap,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: colorMap['color'],
                margin: const EdgeInsets.only(right: 8),
              ),
              Text(colorMap['name']),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeRow(
    BuildContext context, {
    required String label,
    required DateTime dateTime,
    required ValueChanged<DateTime> onDateChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        GestureDetector(
          onTap: () async {
            final DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: dateTime,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(dateTime),
              );
              if (selectedTime != null) {
                final newDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                onDateChanged(newDateTime);
              }
            }
          },
          child: Text(
            '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
          ),
        ),
      ],
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
