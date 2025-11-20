import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/lead.dart';

class DbService {
  DbService._internal();
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'leads.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE leads(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            contact TEXT NOT NULL,
            notes TEXT,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertLead(Lead lead) async {
    final db = await database;
    return await db.insert('leads', lead.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // READ
  Future<List<Lead>> getLeads() async {
    final db = await database;
    final result = await db.query('leads', orderBy: 'id DESC');
    return result.map((e) => Lead.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateLead(Lead lead) async {
    final db = await database;
    return await db.update(
      'leads',
      lead.toMap(),
      where: 'id = ?',
      whereArgs: [lead.id],
    );
  }

  // DELETE
  Future<int> deleteLead(int id) async {
    final db = await database;
    return await db.delete(
      'leads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
