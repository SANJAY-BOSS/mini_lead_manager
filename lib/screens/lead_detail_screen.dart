import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lead.dart';
import '../providers/lead_provider.dart';
import 'add_edit_lead_screen.dart';

class LeadDetailScreen extends StatelessWidget {
  final Lead lead;

  const LeadDetailScreen({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeadProvider>(context, listen: false);
    final statuses = provider.allStatuses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddEditLeadScreen(existingLead: lead),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Lead'),
                  content:
                      const Text('Are you sure you want to delete this lead?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await provider.deleteLead(lead.id!);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<LeadProvider>(
          builder: (context, leadProvider, _) {
            // Get latest version of this lead by id
            final updatedLead = leadProvider.leads
                .firstWhere((l) => l.id == lead.id, orElse: () => lead);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  updatedLead.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone_android, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        updatedLead.contact,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: updatedLead.status,
                  items: statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      await leadProvider.updateStatus(updatedLead, value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Notes / Description',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  updatedLead.notes?.isNotEmpty == true
                      ? updatedLead.notes!
                      : 'No notes added.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
