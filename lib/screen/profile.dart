import 'package:flutter/material.dart';
import 'package:hrms/components/detailscard.dart';
import 'package:hrms/components/experiencecard.dart';
import 'package:hrms/components/livpiechart.dart';
import 'package:hrms/components/profilecard.dart';
import 'package:hrms/components/tabview.dart';
import 'package:hrms/main.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _status = 'Active';

  final Map<int, Map<String, int>> _leaveData = {
    2023: {'Allotted': 20, 'Used': 10, 'Balance': 10, 'sick': 2, 'casual': 4},
    2022: {'Allotted': 18, 'Used': 15, 'Balance': 3, 'sick': 3, 'casual': 4},
    2021: {'Allotted': 16, 'Used': 12, 'Balance': 4, 'sick': 2, 'casual': 3},
  };

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);
    final userData = userDetailsProvider.userDetails;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            DropdownButton<String>(
              style: Theme.of(context).textTheme.bodyMedium,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              value: _status,
              items: <String>['Active', 'Inactive']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: userData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ProfileCard(
                        name: userData['name'] ?? '',
                        employeeCode: userData['employeeCode'] ?? '',
                        jobTitle: userData['role'] ?? '',
                        department: userData['department'] ?? '',
                        dateOfJoining: userData['dateOfJoining'] ?? '',
                        email: userData['email'] ?? '',
                        phone: userData['mobileNo'] ?? '',
                        avatarUrl: userData['avatar'] ?? '',
                      ),
                      const SizedBox(height: 16),
                      DetailsCard(
                        title: 'General Details',
                        details: {
                          'Prefix': userData['Prefix'] ?? '',
                          'Mode of Employment': userData['ModeofEmployment'] ?? '',
                          'Role': userData['role'] ?? '',
                          'Business Unit': userData['BusinessUnit'] ?? '',
                          'Reporting Manager': userData['ReportingManager'] ?? '',
                          'Years of Experience': userData['YearsofExperience'] ?? '',
                        },
                        onEdit: (updatedDetails) {
                          // Handle the updated details here
                        },
                      ),
                      const SizedBox(height: 16),
                      DetailsCard(
                        title: 'Personal Details',
                        details: {
                          'Date of Birth': userData['DateofBirth'] ?? '',
                          'Gender': userData['Gender'] ?? '',
                          'Nationality': userData['Nationality'] ?? '',
                          'Marital Status': userData['MaritalStatus'] ?? '',
                        },
                        onEdit: (updatedDetails) {
                          // Handle the updated details here
                        },
                      ),
                      const SizedBox(height: 16),
                      ExperienceCard(
                        experiences: (userData['workExperience'] as List<dynamic>?)
                            ?.map((exp) => Map<String, String>.from(exp as Map<String, dynamic>))
                            .toList() ?? [],
                        onEdit: (index) {
                          // Handle editing experience at index, or adding new if index is -1
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTabView(
                        title: 'Other Details',
                        tabs: const <Tab>[
                          Tab(text: 'Leaves'),
                          Tab(text: 'Skills'),
                        ],
                        tabViews: <Widget>[
                          LeaveTab(leaveData: _leaveData),
                          const Center(child: Text("No Data Here")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class LeaveTab extends StatefulWidget {
  final Map<int, Map<String, int>> leaveData;

  const LeaveTab({super.key, required this.leaveData});

  @override
  // ignore: library_private_types_in_public_api
  _LeaveTabState createState() => _LeaveTabState();
}

class _LeaveTabState extends State<LeaveTab> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.leaveData.keys.last;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Sick leave: ${widget.leaveData[_selectedYear]?['sick'] ?? '?'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Casual Leave: ${widget.leaveData[_selectedYear]?['casual'] ?? '?'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedYear,
                    items: widget.leaveData.keys.map((int year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                      });
                    },
                    dropdownColor: Theme.of(context).cardColor,
                    icon: const Icon(Icons.arrow_drop_down),
                    isDense: true,
                    menuMaxHeight: 200,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LeavesPieChart(data: widget.leaveData[_selectedYear]!),
            ),
          ],
        );
      },
    );
  }
}
