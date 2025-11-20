import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lead_provider.dart';
import '../widgets/lead_list_item.dart';
import 'add_edit_lead_screen.dart';
import 'lead_detail_screen.dart';

class LeadListScreen extends StatelessWidget {
  const LeadListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeadProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Lead Manager'),
      ),
      body: Column(
        children: [
          // Search + Filter row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search by name (bonus)
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: provider.setSearchQuery,
                  ),
                ),
                const SizedBox(width: 8),
                // Status filter
                DropdownButton<String>(
                  value: provider.statusFilter,
                  items: const [
                    'All',
                    'New',
                    'Contacted',
                    'Converted',
                    'Lost',
                  ].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.setStatusFilter(value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: provider.loadLeads,
              child: Consumer<LeadProvider>(
                builder: (context, leadProvider, _) {
                  final leads = leadProvider.leads;

                  if (leads.isEmpty) {
                    return const Center(
                      child: Text('No leads yet. Tap + to add one.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: leads.length,
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return LeadListItem(
                        lead: lead,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LeadDetailScreen(lead: lead),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddEditLeadScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Lead'),
      ),
    );
  }
}
