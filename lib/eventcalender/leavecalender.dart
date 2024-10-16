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
    // Return the status of the leaves for the current day
    return events.map((leave) => leave['status'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar widget
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2050),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  // Get leaves for the selected day
                  _selectedDayLeaves = _getLeavesForDay(selectedDay);
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
                  color: Colors.blueAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
                leftChevronIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue.shade700,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue.shade700,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    // Get the status of the first event (leave)
                    Object? status = events.first;

                    // Map the status from JSON to corresponding color codes
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

                    // Return a marker for the selected status color
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
              ),
            ),
            // const SizedBox(height: 16),
            // const Spacer(),
            // Display leave details for the selected day
            if (_selectedDayLeaves.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedDayLeaves.length,
                  itemBuilder: (context, index) {
                    final leave = _selectedDayLeaves[index];

                    // Determine the status color for the tag
                    Color statusColor;
                    switch (leave['status']) {
                      case 'Pending':
                        statusColor = Colors.amber;
                        break;
                      case 'Approved':
                        statusColor = Colors.green;
                        break;
                      case 'Declined':
                        statusColor = Colors.redAccent;
                        break;
                      case 'Cancelled':
                        statusColor = Colors.grey;
                        break;
                      default:
                        statusColor = Colors.black;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with status tag
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  leave['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    leave['status'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Leave details
                            Text("Start Date: ${leave['start_date']}",
                                style: const TextStyle(fontSize: 14)),
                            Text("End Date: ${leave['end_date']}",
                                style: const TextStyle(fontSize: 14)),
                            Text("Reason: ${leave['reason']}",
                                style: const TextStyle(fontSize: 14)),
                            Text("Applied On: ${leave['applied_on']}",
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Text(
                'No leaves for the selected day',
                style: TextStyle(fontSize: 16),
              ),
            // const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Spacer(),
            // Dots Legend for different status at the bottom of the screen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend(Colors.amber, "Pending"),
                _buildLegend(Colors.green, "Approved"),
                _buildLegend(Colors.redAccent, "Declined"),
                _buildLegend(Colors.grey, "Cancelled"),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Widget to build the legend items
  Widget _buildLegend(Color color, String status) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          status,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
