import 'package:flutter/material.dart';

class TilesCard extends StatelessWidget {
  final String pendingCount;
  final String requestCount;
  final String totalCount;
  final String availableCount;

  const TilesCard({
    super.key,
    required this.pendingCount,
    required this.requestCount,
    required this.totalCount,
    required this.availableCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildInfoTile('Pending', pendingCount, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildInfoTile('Request', requestCount, Colors.blue)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildInfoTile('Total', totalCount, Colors.green)),
              const SizedBox(width: 16),
              Expanded(
                  child:
                      _buildInfoTile('Available', availableCount, Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, Color color) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 5,
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Icon(
                        _getIconForTitle(title),
                        color: color,
                        size: 48,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'request':
        return Icons.request_page;
      case 'total':
        return Icons.people;
      case 'available':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }
}
