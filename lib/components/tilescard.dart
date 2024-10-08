import 'package:flutter/material.dart';

class TilesCard extends StatelessWidget {
  final List<TileData> tiles;

  const TilesCard({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          for (int i = 0; i < tiles.length; i += 2)
            Column(
              children: [
                if (i > 0) const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildInfoTile(tiles[i])),
                    const SizedBox(width: 16),
                    Expanded(child: i + 1 < tiles.length ? _buildInfoTile(tiles[i + 1]) : const SizedBox()),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(TileData tileData) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: tileData.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 5,
            height: 100,
            decoration: BoxDecoration(
              color: tileData.color,
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
                    tileData.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: tileData.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tileData.value,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: tileData.color,
                        ),
                      ),
                      Icon(
                        tileData.icon,
                        color: tileData.color,
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
}

class TileData {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  TileData({required this.title, required this.value, required this.color, required this.icon});
}
