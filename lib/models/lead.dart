class Lead {
  final int? id;
  final String name;
  final String contact;
  final String? notes;
  final String status; // 'New', 'Contacted', 'Converted', 'Lost'

  Lead({
    this.id,
    required this.name,
    required this.contact,
    this.notes,
    required this.status,
  });

  Lead copyWith({
    int? id,
    String? name,
    String? contact,
    String? notes,
    String? status,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'notes': notes,
      'status': status,
    };
  }

  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'] as int?,
      name: map['name'] as String,
      contact: map['contact'] as String,
      notes: map['notes'] as String?,
      status: map['status'] as String,
    );
  }
}
