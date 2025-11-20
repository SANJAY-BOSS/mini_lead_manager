import 'package:flutter/material.dart';

import '../models/lead.dart';

class LeadListItem extends StatelessWidget {
  final Lead lead;
  final VoidCallback? onTap;

  const LeadListItem({
    super.key,
    required this.lead,
    this.onTap,
  });

  Color _statusColor(String status, BuildContext context) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'Contacted':
        return Colors.orange;
      case 'Converted':
        return Colors.green;
      case 'Lost':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        title: Text(
          lead.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(lead.contact),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(lead.status, context).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            lead.status,
            style: TextStyle(
              color: _statusColor(lead.status, context),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
