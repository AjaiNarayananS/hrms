import 'package:flutter/material.dart';
import 'package:hrms/timemangement/timesheetentry.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:intl/intl.dart';

// Dummy JSON data structure
final Map<String, dynamic> dummyTimesheetData = {
  "user1": {
    "2024": {
      "10": {
        // October
        "workingDays": 22,
        "totalHours": 48,
        "entries": {
          "1": {"hours": 8, "status": "Approved"},
          "2": {"hours": 8, "status": "For approval"},
          "3": {"hours": 8, "status": "Approved"},
          "4": {"hours": 0, "status": "Missing"},
          "7": {"hours": 8, "status": "Approved"},
          "8": {"hours": 8, "status": "For approval"},
          "9": {"hours": 8, "status": "Approved"},
        }
      }
    }
  },
};

class TimesheetCalendar extends StatefulWidget {
  const TimesheetCalendar({super.key});

  @override
  State<TimesheetCalendar> createState() => _TimesheetCalendarState();
}

class _TimesheetCalendarState extends State<TimesheetCalendar> {
  late DateTime _selectedDate;
  late List<Timesheet> _timesheetData;
  final GlobalKey _calendarKey = GlobalKey();
  String userId = "user1";
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _timesheetData = _getTimesheetDataFromJson(_selectedDate, userId);
  }

  List<Timesheet> _getTimesheetDataFromJson(DateTime date, String userId) {
    List<Timesheet> data = [];
    // Check if data exists for the specified user
    final userData = dummyTimesheetData[userId];
    if (userData != null) {
      final yearData = userData[date.year.toString()];
      if (yearData != null) {
        final monthData = yearData[date.month.toString()];
        if (monthData != null) {
          final entries = monthData['entries'] as Map<String, dynamic>;
          entries.forEach((day, entry) {
            data.add(Timesheet(
              DateTime(date.year, date.month, int.parse(day)),
              entry['hours'] as int,
              entry['status'] as String,
            ));
          });
        }
      }
    }
    return data;
  }

  int _getTotalHoursFromJson(DateTime date) {
    final userData = dummyTimesheetData[userId];
    return userData?[date.year.toString()]?[date.month.toString()]
            ?['totalHours'] as int? ??
        0;
  }

  int _getWorkingDaysFromJson(DateTime date) {
    final userData = dummyTimesheetData[userId];
    return userData?[date.year.toString()]?[date.month.toString()]
            ?['workingDays'] as int? ??
        0;
  }

  void _onViewChanged(ViewChangedDetails details) {
    if (details.visibleDates.isNotEmpty) {
      DateTime newDate = details.visibleDates[details.visibleDates.length ~/ 2];
      if (newDate.month != _selectedDate.month ||
          newDate.year != _selectedDate.year) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedDate = DateTime(newDate.year, newDate.month, 1);
            _timesheetData = _getTimesheetDataFromJson(_selectedDate, userId);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recalculate total hours and working days based on _selectedDate
    int totalHours = _getTotalHoursFromJson(_selectedDate);
    int totalWorkingDays = _getWorkingDaysFromJson(_selectedDate);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetricColumn(
                      'Total Hours',
                      '$totalHours',
                      'hrs',
                      Icons.timer,
                      Colors.blue,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    _buildMetricColumn(
                      'Working Days',
                      '$totalWorkingDays',
                      'days',
                      Icons.calendar_today,
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Icons.check_circle, Colors.green, 'Approved'),
                _buildLegendItem(
                    Icons.hourglass_empty, Colors.orange, 'Pending'),
                _buildLegendItem(Icons.cancel, Colors.red, 'Missing'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SfCalendar(
              key: _calendarKey,
              todayHighlightColor: Theme.of(context).secondaryHeaderColor,
              onTap: (calendarTapDetails) {
                if (calendarTapDetails.targetElement ==
                    CalendarElement.calendarCell) {
                  DateTime tappedDate = calendarTapDetails.date!;

                  // Check if the tapped date is today or in the past
                  if (tappedDate.isBefore(DateTime.now()) ||
                      tappedDate.isAtSameMomentAs(DateTime.now())) {
                    Timesheet? tappedEntry = _timesheetData.firstWhere(
                      (entry) => isSameDay(entry.date, tappedDate),
                      orElse: () => Timesheet(tappedDate, 0, 'No entry'),
                    );

                    print(
                        'Date: ${tappedEntry.date.toLocal()}, Hours Worked: ${tappedEntry.hoursWorked}, Status: ${tappedEntry.status}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimesheetEntry(
                          date: tappedEntry.date.toLocal(),
                        ),
                      ),
                    );
                  } else {
                    // Show a message or do nothing if it's a future date
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Cannot add timesheet entry for future dates.')),
                    );
                  }
                }
              },
              showWeekNumber: true,
              showDatePickerButton: true,
              showTodayButton: true,
              view: CalendarView.month,
              onViewChanged: _onViewChanged,
              dataSource: TimesheetDataSource(_timesheetData),
              monthViewSettings: const MonthViewSettings(
                showAgenda: false,
                numberOfWeeksInView: 6,
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(fontSize: 12, color: Colors.black87),
                  trailingDatesTextStyle:
                      TextStyle(fontSize: 12, color: Colors.grey),
                  leadingDatesTextStyle:
                      TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              monthCellBuilder:
                  (BuildContext context, MonthCellDetails details) {
                return _buildMonthCell(details);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(
      String label, String value, String unit, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            // color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMonthCell(MonthCellDetails details) {
    final timesheetData = details.appointments.isNotEmpty
        ? details.appointments[0] as Timesheet
        : null;

    DateTime cellDate = details.date;
    bool isToday = isSameDay(cellDate, DateTime.now());
    bool isWeekend = cellDate.weekday == 6 || cellDate.weekday == 7;
    bool isCurrentMonth = cellDate.month == _selectedDate.month;

    Color textColor = isWeekend
        ? Colors.grey
        : isCurrentMonth
            ? Theme.of(context).hintColor
            : Colors.grey.withOpacity(0.5);

    return Container(
      decoration: BoxDecoration(
        color: isToday ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                cellDate.day.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ),
          if (!isWeekend && isCurrentMonth)
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (timesheetData != null) ...[
                    Text(
                      '${timesheetData.hoursWorked}hr',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Icon(
                      _getStatusIcon(timesheetData.status),
                      color: _getStatusColor(timesheetData.status),
                      size: 16,
                    ),
                  ] else if (!cellDate.isAfter(DateTime.now())) ...[
                    const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'for approval':
        return Icons.hourglass_empty;
      case 'missing':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'for approval':
        return Colors.orange;
      case 'missing':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class Timesheet {
  Timesheet(this.date, this.hoursWorked, this.status);

  DateTime date;
  int hoursWorked;
  String status;
}

class TimesheetDataSource extends CalendarDataSource {
  TimesheetDataSource(List<Timesheet> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

  @override
  String getSubject(int index) {
    return '${appointments![index].hoursWorked}hr';
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
