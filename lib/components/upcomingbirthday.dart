import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class UpcomingBirthdays extends StatelessWidget {
  final List<Map<String, dynamic>> birthdays;

  const UpcomingBirthdays({super.key, required this.birthdays});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upcoming Birthdays',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildBirthdayTimeline(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBirthdayTimeline(BuildContext context) {
    return Column(
      children: List.generate(birthdays.length, (index) {
        final birthday = birthdays[index];
        final isToday = DateFormat('MMM\nd').format(birthday['date']) ==
            DateFormat('MMM\nd').format(DateTime.now());

        return TimelineTile(
          alignment: TimelineAlign.start,
          lineXY: 0.15,
          isFirst: index == 0,
          isLast: index == birthdays.length - 1,
          indicatorStyle: IndicatorStyle(
            width: 50,
            height: 50,
            indicator: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isToday ? Theme.of(context).focusColor : Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('MMM\nd').format(birthday['date']),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          endChild: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: _buildBirthdayCard(
              context,  // Pass context here
              birthday['name'],
              birthday['role'],
              birthday['email'],
              birthday['image'],
              isToday,
            ),
          ),
          beforeLineStyle: LineStyle(
            color: Theme.of(context).focusColor,
            thickness: 2,
          ),
        );
      }),
    );
  }

  Widget _buildBirthdayCard(
    BuildContext context,  // Add context parameter
    String name,
    String role,
    String email,
    String imageUrl,
    bool isToday
  ) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
      color: isToday ? Theme.of(context).focusColor : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Column(
              children: [
                if (isToday)
                  Image.asset(
                    'assets/hat.gif',
                    width: 40,
                    height: 40,
                  ),
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 25,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      role,
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
