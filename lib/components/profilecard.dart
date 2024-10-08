import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String employeeCode;
  final String jobTitle;
  final String department;
  final String dateOfJoining;
  final String email;
  final String phone;
  final String avatarUrl;

  const ProfileCard({
    super.key,
    required this.name,
    required this.employeeCode,
    required this.jobTitle,
    required this.department,
    required this.dateOfJoining,
    required this.email,
    required this.phone,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: employeeCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Employee code copied to clipboard')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(employeeCode,
                                      style: Theme.of(context).textTheme.bodySmall),
                                  const SizedBox(width: 4),
                                  Icon(Icons.copy, size: 14, color: Theme.of(context).primaryColor),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          jobTitle,
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Department',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium),
                      Text(department,
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
                      Text(dateOfJoining,
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
                    title: Text(email,
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
                    title: Text(phone,
                        style:
                            Theme.of(context).textTheme.labelLarge),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}