import 'package:flutter/material.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _status = 'Active';
  List<Map<String, dynamic>> _experiences = [];
  Map<String, String> _personalDetails = {
    'Date of Birth': '15/05/1990',
    'Gender': 'Male',
    'Nationality': 'American',
    'Marital Status': 'Single',
  };

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  void _loadExperiences() {
    String jsonString = '''
    [
      {
        "role": "Project Manager",
        "company": "Rits Consulting",
        "location": "Bangalore, India",
        "date": "Jan 2020 - Present",
        "logoUrl": "https://th.bing.com/th/id/R.0d64b05dfd05db057c80c3e815ca47b4?rik=P8RLfkg%2fq%2famBg&riu=http%3a%2f%2fwww.ritsconsulting.com%2fwp-content%2fuploads%2f2018%2f09%2fritsConsulting-New.png&ehk=wOcUZfk5z3zz%2fYmTZuZcP0tlA3rU%2fzEabAORRTiaI2k%3d&risl=&pid=ImgRaw&r=0"
      },
      {
        "role": "Senior Developer",
        "company": "Rits Consulting",
        "location": "Bangalore, India",
        "date": "Mar 2015 - Dec 2019",
        "logoUrl": "https://th.bing.com/th/id/R.0d64b05dfd05db057c80c3e815ca47b4?rik=P8RLfkg%2fq%2famBg&riu=http%3a%2f%2fwww.ritsconsulting.com%2fwp-content%2fuploads%2f2018%2f09%2fritsConsulting-New.png&ehk=wOcUZfk5z3zz%2fYmTZuZcP0tlA3rU%2fzEabAORRTiaI2k%3d&risl=&pid=ImgRaw&r=0"
      }
    ]
    ''';

    setState(() {
      _experiences = List<Map<String, dynamic>>.from(json.decode(jsonString));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineLarge,),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.1),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                'https://www.bing.com/th?id=OIP.jQvFuRlmVesA7K6ArjfyrAHaH9&w=150&h=161&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('John Doe',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Software Developer',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Department',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text('Testing',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date of Joining',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text('01/01/2023',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).focusColor.withOpacity(0.2),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.email,
                                size: 19,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              title: Text('john.doe@example.com',
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                            ),
                            const Divider(
                              height: 0.1,
                              thickness: 0.1,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.phone,
                                size: 19,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              title: Text('+1 234 567 8900',
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.1),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Personal Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showEditDialog(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      size: 12,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._personalDetails.entries.map(
                          (entry) => _buildDetailRow(entry.key, entry.value)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.1),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Experience',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Implement edit functionality
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      size: 10,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._experiences.map((exp) => _buildExperienceItem(
                            role: exp['role'],
                            company: exp['company'],
                            location: exp['location'],
                            date: exp['date'],
                            logoUrl: exp['logoUrl'],
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(
          height: 0.1,
          thickness: 0.1,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildExperienceItem({
    required String role,
    required String company,
    required String location,
    required String date,
    required String logoUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(logoUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role, style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(company,
                          style: Theme.of(context).textTheme.bodyLarge),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16, color: Theme.of(context).hintColor),
                          const SizedBox(width: 4),
                          Text(location,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today,
                size: 16, color: Theme.of(context).hintColor),
            const SizedBox(width: 4),
            Text(date, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(
          height: 0.1,
          thickness: 0.1,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Map<String, String> editedDetails = Map.from(_personalDetails);
            return AlertDialog(
              title: Text('Edit Personal Details',
                  style: Theme.of(context).textTheme.headlineSmall),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _personalDetails.keys.map((key) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: key,
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 1),
                            ),
                          ),
                          controller:
                              TextEditingController(text: editedDetails[key]),
                          onChanged: (value) {
                            editedDetails[key] = value;
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel',
                      style: Theme.of(context).textTheme.labelLarge),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Save',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      _personalDetails = editedDetails;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        );
      },
    );
  }
}
