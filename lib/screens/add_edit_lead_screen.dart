import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lead.dart';
import '../providers/lead_provider.dart';

class AddEditLeadScreen extends StatefulWidget {
  final Lead? existingLead;

  const AddEditLeadScreen({super.key, this.existingLead});

  @override
  State<AddEditLeadScreen> createState() => _AddEditLeadScreenState();
}

class _AddEditLeadScreenState extends State<AddEditLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _notesController;
  late String _status;

  @override
  void initState() {
    super.initState();
    final lead = widget.existingLead;
    _nameController = TextEditingController(text: lead?.name ?? '');
    _contactController = TextEditingController(text: lead?.contact ?? '');
    _notesController = TextEditingController(text: lead?.notes ?? '');
    _status = lead?.status ?? 'New';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveLead() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<LeadProvider>(context, listen: false);
    final isEditing = widget.existingLead != null;

    final lead = Lead(
      id: widget.existingLead?.id,
      name: _nameController.text.trim(),
      contact: _contactController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      status: _status,
    );

    if (isEditing) {
      await provider.updateLead(lead);
    } else {
      await provider.addLead(lead);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingLead != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Lead' : 'Add Lead'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name (required)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Contact (required)
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact (phone / email) *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Contact is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Notes (optional)
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              // Status
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
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
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saveLead,
                child: Text(isEditing ? 'Save Changes' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
