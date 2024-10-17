import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Don't forget to add intl package in pubspec.yaml

class TimesheetEntry extends StatefulWidget {
  const TimesheetEntry({super.key, this.date});
  final DateTime? date;

  @override
  _TimesheetEntryState createState() => _TimesheetEntryState();
}

class _TimesheetEntryState extends State<TimesheetEntry> {
  double totalHoursWorked = 0;
  List<ModuleEntry> moduleEntries = [];

  // Sample JSON data for projects and their modules
  final List<Map<String, dynamic>> projects = [
    {
      "project_id": "1",
      "project_name": "Project A",
      "modules": [
        {"module_id": "1", "module_name": "Module A1"},
        {"module_id": "2", "module_name": "Module A2"},
      ]
    },
    {
      "project_id": "2",
      "project_name": "Project B",
      "modules": [
        {"module_id": "1", "module_name": "Module B1"},
        {"module_id": "2", "module_name": "Module B2"},
      ]
    },
    {
      "project_id": "3",
      "project_name": "Project C",
      "modules": [
        {"module_id": "1", "module_name": "Module C1"},
        {"module_id": "2", "module_name": "Module C2"},
      ]
    },
  ];

  String get currentDate {
    if (widget.date != null) {
      return DateFormat('d MMMM y').format(widget.date!);
    } else {
      return 'Date not available';
    }
  }

  void addEntry() {
    setState(() {
      moduleEntries.add(ModuleEntry());
    });
  }

  void deleteEntry(int index) {
    setState(() {
      moduleEntries.removeAt(index);
      updateTotalHours(); // Recalculate total hours after deletion
    });
  }

  void updateTotalHours() {
    double total = 0;
    for (var entry in moduleEntries) {
      total += entry.hoursWorked ?? 0;
    }
    setState(() {
      totalHoursWorked = total;
    });
  }

  void submitEntries() {
    // Logic to save or submit the entries
    for (var entry in moduleEntries) {
      print(
          'Project: ${entry.selectedProject}, Module: ${entry.selectedModule}, Hours: ${entry.hoursWorked}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timesheet Entry'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Date and Total Hours Worked Card
          Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    currentDate,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Hours Worked: ${totalHoursWorked.toStringAsFixed(1)} hrs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dynamic List of Module Entries
          Expanded(
            child: ListView.builder(
              itemCount: moduleEntries.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ModuleEntryWidget(
                          entry: moduleEntries[index],
                          projects: projects,
                          onEntryChanged: updateTotalHours,
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteEntry(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: addEntry,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Module Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: submitEntries,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Submit Entries'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Model class to represent an entry for a project module and hours worked
class ModuleEntry {
  String? selectedProject;
  String? selectedModule;
  double? hoursWorked;
}

// Widget to display each module entry row
class ModuleEntryWidget extends StatelessWidget {
  final ModuleEntry entry;
  final List<Map<String, dynamic>> projects;
  final Function onEntryChanged;

  const ModuleEntryWidget({
    super.key,
    required this.entry,
    required this.projects,
    required this.onEntryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Project Dropdown
        Flexible(
          flex: 3,
          child: SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              value: entry.selectedProject,
              hint: const Text('Project'),
              decoration: InputDecoration(
                filled: true,
                // fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              ),
              items: projects.map<DropdownMenuItem<String>>((project) {
                return DropdownMenuItem<String>(
                  value: project["project_name"] as String,
                  child: Text(project["project_name"] as String,
                      overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (value) {
                entry.selectedProject = value;
                entry.selectedModule =
                    null; // Reset module when project changes
                onEntryChanged();
              },
            ),
          ),
        ),
        const SizedBox(width: 4),

        // Module Dropdown
        Flexible(
          flex: 3,
          child: SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              value: entry.selectedModule,
              hint: const Text('Module'),
              decoration: InputDecoration(
                filled: true,
                // fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              ),
              items: entry.selectedProject != null
                  ? projects
                      .firstWhere((project) =>
                          project["project_name"] ==
                          entry.selectedProject)['modules']
                      .map<DropdownMenuItem<String>>((module) {
                      return DropdownMenuItem<String>(
                        value: module["module_name"] as String,
                        child: Text(module["module_name"] as String,
                            overflow: TextOverflow.ellipsis),
                      );
                    }).toList()
                  : [],
              onChanged: (value) {
                entry.selectedModule = value;
                onEntryChanged();
              },
            ),
          ),
        ),
        const SizedBox(width: 4),

        // Hours Worked Input
        Flexible(
          flex: 2,
          child: SizedBox(
            width: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Hrs',
                filled: true,
                // fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              ),
              onChanged: (value) {
                entry.hoursWorked =
                    double.tryParse(value) ?? 0; // Handle non-numeric input
                onEntryChanged();
              },
            ),
          ),
        ),
      ],
    );
  }
}
