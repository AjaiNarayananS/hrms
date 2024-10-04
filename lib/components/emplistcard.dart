import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String role;
  final String applicationDate;
  final String email;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.role,
    required this.applicationDate,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showEmployeeDetails(context);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://th.bing.com/th/id/OIP.Ta3GX6-k2iyMQt00doRnBQHaHa?w=195&h=195&c=7&r=0&o=5&dpr=1.3&p'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: Theme.of(context).textTheme.titleLarge),
                        Row(
                          children: [
                            Text(role,
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Active',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // TODO: Implement more options functionality
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Application Date:',
                      style: Theme.of(context).textTheme.labelSmall),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(applicationDate,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(email,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.end),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              'https://th.bing.com/th/id/OIP.Ta3GX6-k2iyMQt00doRnBQHaHa?w=195&h=195&c=7&r=0&o=5&dpr=1.3&p'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              const SizedBox(height: 4),
                              Text(role,
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('Active',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                        height: 10,
                        thickness: 0.2,
                        color: Color.fromARGB(255, 178, 177, 177)),
                    const SizedBox(height: 20),
                    Text('Personal Information',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    _buildDetailRow(context, 'Date of Birth', '01/01/1990', Icons.cake),
                    _buildDetailRow(context, 'Phone', '+1 234 567 8900', Icons.phone),
                    _buildDetailRow(context, 'Address', '123 Main St, City, Country', Icons.home),
                    const SizedBox(height: 20),
                    Text('Employment Information',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    _buildDetailRow(context, 'Application Date', applicationDate, Icons.calendar_month),
                    _buildDetailRow(context, 'Email', email, Icons.mail),
                    // Add more employment details as needed
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Theme.of(context).secondaryHeaderColor),
              const SizedBox(width: 10),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
