import 'package:flutter/material.dart';

class ExperienceCard extends StatelessWidget {
  final List<Map<String, String>> experiences;
  final Function(int) onEdit;

  const ExperienceCard({
    super.key,
    required this.experiences,
    required this.onEdit,
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
                  onTap: () => onEdit(-1), // -1 indicates adding new experience
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 12, color: Theme.of(context).secondaryHeaderColor),
                        const SizedBox(width: 4),
                        Text('Add', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...experiences.asMap().entries.map((entry) => _buildExperienceItem(context, entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem(BuildContext context, int index, Map<String, String> exp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(exp['logoUrl'] ?? ''),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exp['role'] ?? '', style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(exp['company'] ?? '', style: Theme.of(context).textTheme.bodyLarge),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Theme.of(context).hintColor),
                          const SizedBox(width: 4),
                          Text(exp['location'] ?? '', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, size: 16, color: Theme.of(context).hintColor),
              onPressed: () => onEdit(index),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Theme.of(context).hintColor),
            const SizedBox(width: 4),
            Text(exp['date'] ?? '', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 0.1, thickness: 0.1, color: Colors.grey),
        const SizedBox(height: 16),
      ],
    );
  }
}