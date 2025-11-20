import 'package:flutter/material.dart';

import '../models/lead.dart';
import '../services/db_services.dart';

class LeadProvider extends ChangeNotifier {
  final DbService _dbService = DbService();

  List<Lead> _leads = [];
  String _statusFilter = 'All'; // All, New, Contacted, Converted, Lost
  String _searchQuery = '';

  List<Lead> get leads {
    List<Lead> result = _leads;

    if (_statusFilter != 'All') {
      result = result.where((l) => l.status == _statusFilter).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((l) => l.name.toLowerCase().contains(q)).toList();
    }

    return result;
  }

  String get statusFilter => _statusFilter;

  Future<void> loadLeads() async {
    _leads = await _dbService.getLeads();
    notifyListeners();
  }

  Future<void> addLead(Lead lead) async {
    await _dbService.insertLead(lead);
    await loadLeads();
  }

  Future<void> updateLead(Lead lead) async {
    if (lead.id == null) return;
    await _dbService.updateLead(lead);
    await loadLeads();
  }

  Future<void> deleteLead(int id) async {
    await _dbService.deleteLead(id);
    await loadLeads();
  }

  void setStatusFilter(String value) {
    _statusFilter = value;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<void> updateStatus(Lead lead, String newStatus) async {
    final updated = lead.copyWith(status: newStatus);
    await updateLead(updated);
  }

  List<String> get allStatuses => ['New', 'Contacted', 'Converted', 'Lost'];
}
