import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectCreate extends StatefulWidget {
  const ProjectCreate({super.key});

  @override
  State<ProjectCreate> createState() => _ProjectCreateState();
}

class _ProjectCreateState extends State<ProjectCreate> {
  int currentTab = 1;
  String? selectedStatus;
  String? selectedBaseProject;
  String? selectedClient;
  String? selectedCurrency;
  String? selectedProjectType;
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController estimationHoursController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool _showProjectTypeError = false;
  bool _showStartDateError = false;

  // JSON data for dropdowns
  final Map<String, List<String>> dropdownData = {
    'status': ['Initiated', 'In Progress', 'Draft', 'Hold', 'Completed'],
    'baseProject': ['HR Admin', 'CTC'],
    'client': ['Client A', 'Client B'],
    'currency': ['INR', 'USD', 'EUR', 'GBP'],
  };

  List<Task> tasks = [];

  final _formKey = GlobalKey<FormState>();

  // Add this list of employees (you can fetch this from an API in a real app)
  final List<Employee> allEmployees = [
    Employee(
        id: "EMP001",
        name: "USER A",
        role: "Developer",
        profileImage: "https://avatar.iran.liara.run/public/boy?username=Ash"),
    Employee(
        id: "EMP002",
        name: "USER B",
        role: "Designer",
        profileImage: "https://avatar.iran.liara.run/public/boy?username=Ash"),
    Employee(
        id: "EMP003",
        name: "USER C",
        role: "Manager",
        profileImage: "https://avatar.iran.liara.run/public/boy?username=Ash"),
    Employee(
        id: "EMP003",
        name: "USER D",
        role: "Developer",
        profileImage: "https://avatar.iran.liara.run/public/boy?username=Ash"),
    Employee(
        id: "EMP003",
        name: "USER E",
        role: "Trainee",
        profileImage: "https://avatar.iran.liara.run/public/boy?username=Ash"),
    // Add more employees as needed
  ];

  String? _validateProjectType() {
    if (selectedProjectType == null) {
      return 'Please select a project type';
    }
    return null;
  }

  String? _validateStartDate() {
    if (startDate == null) {
      return 'Please select a start date';
    }
    final today = DateTime.now();
    final startDateOnly =
        DateTime(startDate!.year, startDate!.month, startDate!.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (startDateOnly.isBefore(todayOnly)) {
      return 'Start date cannot be in the past';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1976D2), // Replace with your primary color
                Color(
                    0xCC1976D2), // Replace with your primary color at 80% opacity
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            // const Icon(Icons.add_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Create Project',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.info_outline, color: Colors.white),
        //     onPressed: () {
        //       // Show project creation info
        //     },
        //   ),
        // ],
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Projectstep(
                      stepname: "Project Setup",
                      isActive: currentTab == 1,
                      isCompleted: currentTab > 0,
                    ),
                    const SizedBox(width: 40),
                    Projectstep(
                      stepname: "Tasks",
                      isActive: currentTab == 2,
                      isCompleted: currentTab > 1,
                    ),
                    // Projectstep(
                    //   stepname: "Resources",
                    //   textStatus: currentTab == 3 ? true : false,
                    //   borderStatus: currentTab > 2 ? true : false,
                    // )
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (currentTab == 1)
                          _buildProjectSetupForm()
                        else if (currentTab == 2)
                          _buildTasksForm(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: currentTab == 2
          ? FloatingActionButton(
              onPressed: _showAddTaskDialog,
              backgroundColor: Theme.of(context).primaryColor,
              mini: true,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildProjectSetupForm() {
    return Column(
      children: [
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: projectNameController,
                  decoration: InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown('Status', 'status', selectedStatus, Icons.flag),
                const SizedBox(height: 16),
                _buildDropdown('Base Project', 'baseProject',
                    selectedBaseProject, Icons.folder),
                const SizedBox(height: 16),
                _buildDropdown(
                    'Client', 'client', selectedClient, Icons.business),
                const SizedBox(height: 16),
                _buildDropdown('Currency', 'currency', selectedCurrency,
                    Icons.attach_money),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Type',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E88E5))),
                Row(
                  children: [
                    _buildRadioButton('Billable'),
                    _buildRadioButton('Non-Billable'),
                  ],
                ),
                if (_showProjectTypeError && _validateProjectType() != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _validateProjectType()!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePicker('Start Date', startDate),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDatePicker('End Date', endDate),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: estimationHoursController,
                  decoration: InputDecoration(
                    labelText: 'Estimation Hours',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project and Client info at the top
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Project: ${projectNameController.text}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  'Client: ${selectedClient ?? "Not Selected"}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tasks',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E88E5),
          ),
        ),
        const SizedBox(height: 16),
        if (tasks.isEmpty)
          Center(
            child: Text(
              'No tasks added yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...tasks.map((task) => _buildTaskCard(task)),
      ],
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(task.name,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estimated hours: ${task.estimatedHours}',
                style: GoogleFonts.poppins(color: Colors.grey[600])),
            Text('Assigned: ${task.assignedResources.length}',
                style: GoogleFonts.poppins(color: Colors.grey[600])),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.person_add, color: Color(0xFF1E88E5)),
              onPressed: () => _showAssignResourcesDialog(task),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF4CAF50)),
              onPressed: () => _showEditTaskDialog(task),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
              onPressed: () => _deleteTask(task),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    final taskNameController = TextEditingController();
    final estimatedHoursController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: estimatedHoursController,
              decoration: const InputDecoration(labelText: 'Estimated Hours'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tasks.add(Task(
                  name: taskNameController.text,
                  estimatedHours:
                      double.tryParse(estimatedHoursController.text) ?? 0,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    final taskNameController = TextEditingController(text: task.name);
    final estimatedHoursController =
        TextEditingController(text: task.estimatedHours.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: estimatedHoursController,
              decoration: const InputDecoration(labelText: 'Estimated Hours'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                task.name = taskNameController.text;
                task.estimatedHours =
                    double.tryParse(estimatedHoursController.text) ??
                        task.estimatedHours;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            if (currentTab != 1) {
              setState(() {
                currentTab--;
              });
            }
          },
          child: Text("Back",
              style: GoogleFonts.poppins(color: const Color(0xFF1E88E5))),
        ),
        ElevatedButton(
          onPressed: () {
            if (currentTab == 1) {
              setState(() {
                _showProjectTypeError = true;
                _showStartDateError =
                    true; // Show start date error when Next is clicked
              });
              if (_formKey.currentState!.validate() &&
                  _validateProjectType() == null &&
                  _validateStartDate() == null) {
                setState(() {
                  currentTab++;
                  _showProjectTypeError = false;
                  _showStartDateError =
                      false; // Reset errors when moving to next screen
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Please fill all required fields correctly')),
                );
              }
            } else if (currentTab == 2) {
              if (tasks.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add at least one task')),
                );
              } else {
                _saveProject();
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(currentTab == 2 ? "Save" : "Next",
              style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label, String dataKey, String? value, IconData icon) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      items: dropdownData[dataKey]!
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (String? newValue) {
        setState(() {
          switch (dataKey) {
            case 'status':
              selectedStatus = newValue;
              break;
            case 'baseProject':
              selectedBaseProject = newValue;
              break;
            case 'client':
              selectedClient = newValue;
              break;
            case 'currency':
              selectedCurrency = newValue;
              break;
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $label';
        }
        return null;
      },
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedProjectType,
          onChanged: (String? newValue) {
            setState(() {
              selectedProjectType = newValue;
              _showProjectTypeError =
                  false; // Reset error when a selection is made
            });
          },
        ),
        Text(value),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          readOnly: true,
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != date) {
              setState(() {
                if (label == 'Start Date') {
                  startDate = picked;
                  _showStartDateError =
                      false; // Reset error when a new date is picked
                } else {
                  endDate = picked;
                }
              });
            }
          },
          controller: TextEditingController(
            text: date != null ? "${date.toLocal()}".split(' ')[0] : "",
          ),
        ),
        if (label == 'Start Date' &&
            _showStartDateError &&
            _validateStartDate() != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _validateStartDate()!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void _saveProject() {
    final projectData = {
      'projectName': projectNameController.text,
      'status': selectedStatus,
      'baseProject': selectedBaseProject,
      'client': selectedClient,
      'currency': selectedCurrency,
      'projectType': selectedProjectType,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'estimationHours': estimationHoursController.text,
      'description': descriptionController.text,
      'tasks': tasks
          .map((task) => {
                'name': task.name,
                'estimatedHours': task.estimatedHours,
                'assignedResources': task.assignedResources
                    .map((employee) => {
                          'id': employee.id,
                          'name': employee.name,
                          'role': employee.role,
                        })
                    .toList(),
              })
          .toList(),
    };

    print(json.encode(projectData));
    // TODO: Send this data to your backend or process it as needed
  }

  void _showAssignResourcesDialog(Task task) {
    final TextEditingController searchController = TextEditingController();
    List<Employee> filteredEmployees = List.from(allEmployees);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Assign Resources',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search employees',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredEmployees = allEmployees
                              .where((employee) =>
                                  employee.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  employee.id
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  employee.role
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                const Tab(text: 'Resources'),
                                Tab(
                                    text:
                                        'Selected (${task.assignedResources.length})'),
                              ],
                              labelColor: const Color(0xFF1E88E5),
                              unselectedLabelColor: Colors.grey,
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  _buildResourcesList(
                                      task, setState, filteredEmployees),
                                  _buildSelectedResourcesList(task, setState),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel', style: GoogleFonts.poppins()),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5)),
                  onPressed: () {
                    setState(() {
                      // Update the task's assigned resources
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Assign',
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Update the parent widget's state after the dialog is closed
      setState(() {});
    });
  }

  Widget _buildResourcesList(
      Task task, StateSetter setState, List<Employee> filteredEmployees) {
    return ListView.builder(
      itemCount: filteredEmployees.length,
      itemBuilder: (context, index) {
        final employee = filteredEmployees[index];
        final isAssigned =
            task.assignedResources.any((e) => e.id == employee.id);
        return Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 16 : 4,
            bottom: 4,
            left: 8,
            right: 8,
          ),
          child: Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isAssigned) {
                    task.assignedResources
                        .removeWhere((e) => e.id == employee.id);
                  } else {
                    task.assignedResources.add(employee);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(employee.profileImage),
                      radius: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.name,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            employee.id,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            employee.role,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: isAssigned,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            task.assignedResources.add(employee);
                          } else {
                            task.assignedResources
                                .removeWhere((e) => e.id == employee.id);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedResourcesList(Task task, StateSetter setState) {
    return ListView.builder(
      itemCount: task.assignedResources.length,
      itemBuilder: (context, index) {
        final employee = task.assignedResources[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(employee.profileImage),
                    radius: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          employee.id,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        Text(
                          employee.role,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        task.assignedResources.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Projectstep extends StatelessWidget {
  const Projectstep({
    super.key,
    required this.stepname,
    required this.isActive,
    required this.isCompleted,
  });

  final String stepname;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            stepname,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class Task {
  String name;
  double estimatedHours;
  List<Employee> assignedResources;

  Task({
    required this.name,
    required this.estimatedHours,
    List<Employee>? assignedResources,
  }) : assignedResources = assignedResources ?? [];
}

class Employee {
  final String id;
  final String name;
  final String role;
  final String profileImage;

  Employee(
      {required this.id,
      required this.name,
      required this.role,
      required this.profileImage});
}
