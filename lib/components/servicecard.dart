import 'package:flutter/material.dart';

class Servicecard extends StatefulWidget {
  final String title;
  final Map<String, String> details;
  final Function(Map<String, String>) onEdit;

  const Servicecard({
    super.key,
    required this.title,
    required this.details,
    required this.onEdit,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ServicecardState createState() => _ServicecardState();
}

class _ServicecardState extends State<Servicecard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300, width: 0.1),
      ),
      elevation: 0,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _buildActionButton(
                        context,
                        'Edit',
                        Icons.edit,
                        () => _showEditDialog(context),
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        context,
                        'Delete',
                        Icons.delete,
                        () => _showDeleteConfirmation(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...widget.details.entries.map((entry) => _buildDetailRow(entry.key, entry.value)),
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
        const Divider(height: 0.1, thickness: 0.1, color: Colors.grey),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: Theme.of(context).secondaryHeaderColor),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Map<String, String> editedDetails = Map.from(widget.details);
            return AlertDialog(
              title: Text('Edit ${widget.title}', style: Theme.of(context).textTheme.headlineSmall),
              content: ConstrainedBox(
                constraints:const BoxConstraints(
                  maxHeight: 500, // Set maximum height to 500 pixels
                  // maxWidth: MediaQuery.of(context).size.width * 0.8,
                  minWidth: 1000
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: editedDetails.keys.map((key) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: key,
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          controller: TextEditingController(text: editedDetails[key]),
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
                  child: Text('Cancel', style: Theme.of(context).textTheme.labelLarge),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Save', style: TextStyle(fontSize: 14, color: Colors.white)),
                  onPressed: () {
                    widget.onEdit(editedDetails);
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${widget.title}?'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement delete functionality
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
