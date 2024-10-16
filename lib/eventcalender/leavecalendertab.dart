import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

// Dummy JSON data
const String jsonData = '''
[
  {
    "title": "Sick Leave",
    "status": "Pending",
    "start_date": "2024-10-03",
    "end_date": "2024-10-03",
    "reason": "Not feeling well",
    "applied_on": "2024-10-01"
  },
  {
    "title": "Vacation",
    "status": "Approved",
    "start_date": "2024-10-05",
    "end_date": "2024-10-10",
    "reason": "Going on a trip",
    "applied_on": "2024-09-20"
  },
  {
    "title": "Emergency Leave",
    "status": "Declined",
    "start_date": "2024-10-08",
    "end_date": "2024-10-08",
    "reason": "Personal reasons",
    "applied_on": "2024-10-06"
  },
  {
    "title": "Medical Leave",
    "status": "Pending",
    "start_date": "2024-10-12",
    "end_date": "2024-10-13",
    "reason": "Medical appointment",
    "applied_on": "2024-10-10"
  },
  {
    "title": "Medical Leave",
    "status": "Pending",
    "start_date": "2024-11-12",
    "end_date": "2024-11-16",
    "reason": "Medical appointment",
    "applied_on": "2024-11-10"
  },
  {
    "title": "Work from Home",
    "status": "Cancelled",
    "start_date": "2024-10-22",
    "end_date": "2024-10-22",
    "reason": "Internet issue resolved",
    "applied_on": "2024-10-21"
  }
]
''';

class LeaveTab extends StatefulWidget {
  const LeaveTab({super.key});

  @override
  _LeaveTabState createState() => _LeaveTabState();
}

class _LeaveTabState extends State<LeaveTab> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<dynamic> _leaveData = [];
  List<dynamic> _selectedDayLeaves = [];
  Color? _selectedDayColor;

  @override
  void initState() {
    super.initState();
    // Parse the JSON data into the _leaveData list
    _leaveData = json.decode(jsonData);
  }

  // Function to get leave data for the selected day
  List<dynamic> _getLeavesForDay(DateTime day) {
    return _leaveData.where((leave) {
      DateTime startDate = DateTime.parse(leave['start_date']);
      DateTime endDate = DateTime.parse(leave['end_date']);
      return day.isAtSameMomentAs(startDate) ||
          (day.isAfter(startDate) &&
              day.isBefore(endDate.add(const Duration(days: 1))));
    }).toList();
  }

  // Event loader to show the leave status for each day
  List<String> _eventLoader(DateTime day) {
    List<dynamic> events = _getLeavesForDay(day);
    return events.map((leave) => leave['status'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2050),
              rowHeight: 60,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedDayLeaves = _getLeavesForDay(selectedDay);
                  if (_selectedDayLeaves.isNotEmpty) {
                    String status = _selectedDayLeaves.first['status'];
                    _selectedDayColor = _getStatusColor(status);
                  } else {
                    _selectedDayColor = Colors.orangeAccent;
                  }
                });
              },
              calendarFormat: _calendarFormat,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _eventLoader,
              calendarStyle: CalendarStyle(
                markersMaxCount: 1,
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // color: Colors.blue.shade700,
                ),
                leftChevronIcon: Icon(
                  Icons.arrow_back_ios,
                  // color: Colors.blue.shade700,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_forward_ios,
                  // color: Colors.blue.shade700,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    Object? status = events.first;
                    Color? markerColor;
                    switch (status) {
                      case 'Pending':
                        markerColor = Colors.amber;
                        break;
                      case 'Approved':
                        markerColor = Colors.green;
                        break;
                      case 'Declined':
                        markerColor = Colors.redAccent;
                        break;
                      case 'Cancelled':
                        markerColor = Colors.grey;
                        break;
                    }
                    if (markerColor != null) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: markerColor,
                          shape: BoxShape.circle,
                        ),
                      );
                    }
                  }
                  return null;
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: _selectedDayColor ?? Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            if (_selectedDayLeaves.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedDayLeaves.length,
                  itemBuilder: (context, index) {
                    final leave = _selectedDayLeaves[index];
                    Color statusColor = _getStatusColor(leave['status']);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 6,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        constraints: const BoxConstraints(
                          minHeight: 180,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  leave['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    leave['status'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.date_range,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'Start Date: ${leave['start_date']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.date_range,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'End Date: ${leave['end_date']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.notes, color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    leave['reason'],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Legend at the bottom
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(
                      Colors.amber, 'Pending', Icons.hourglass_empty),
                  _buildLegendItem(
                      Colors.green, 'Approved', Icons.check_circle),
                  _buildLegendItem(Colors.redAccent, 'Declined', Icons.cancel),
                  _buildLegendItem(
                      Colors.grey, 'Cancelled', Icons.not_interested),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to return the color based on the leave status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.amber;
      case 'Approved':
        return Colors.green;
      case 'Declined':
        return Colors.redAccent;
      case 'Cancelled':
        return Colors.grey;
      default:
        return Colors.orangeAccent;
    }
  }

  // Helper function to build legend item
  Widget _buildLegendItem(Color color, String status, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 4),
        Text(
          status,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
