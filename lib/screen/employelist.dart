import 'package:flutter/material.dart';
import 'package:hrms/components/emplistcard.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Map<String, String>> allEmployees = [
    {
      'name': 'John Doe',
      'role': 'Software Engineer',
      'applicationDate': '2023-01-15',
      'email': 'john.doe@example.com',
    },
    {
      'name': 'Jane Smith',
      'role': 'Product Manager',
      'applicationDate': '2023-02-20',
      'email': 'jane.smith@example.com',
    },
    {
      'name': 'Mike Johnson',
      'role': 'UX Designer',
      'applicationDate': '2023-03-10',
      'email': 'mike.johnson@example.com',
    },
    {
      'name': 'Emily Brown',
      'role': 'Data Analyst',
      'applicationDate': '2023-04-05',
      'email': 'emily.brown@example.com',
    },
    {
      'name': 'David Lee',
      'role': 'DevOps Engineer',
      'applicationDate': '2023-05-01',
      'email': 'david.lee@example.com',
    },
  ];

  List<Map<String, String>> filteredEmployees = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredEmployees = allEmployees;
    searchController.addListener(_filterEmployees);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterEmployees() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEmployees = allEmployees
          .where((employee) => employee['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List', style: Theme.of(context).textTheme.headlineLarge,),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search employees...',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {
                      // TODO: Implement filter functionality
                    },
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = filteredEmployees[index];
                return EmployeeCard(
                  name: employee['name']!,
                  role: employee['role']!,
                  applicationDate: employee['applicationDate']!,
                  email: employee['email']!,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
