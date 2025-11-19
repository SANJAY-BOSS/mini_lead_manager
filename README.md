# mini_lead_manager
A simple offline CRM-style Flutter app to manage leads. Features include adding, editing, updating status, deleting, filtering by status, and searching leads — all stored locally using SQLite. Built with clean architecture and Provider state management.

App Overview:
This app helps you manage leads like a small CRM.
You can add new leads, edit their details, update their status, and delete them whenever needed.
All leads are saved offline inside the phone using a local database.
You can also filter leads by status (New, Contacted, Converted, Lost) and search by name to find them quickly.

How To Run:
Clone this github repository and run in visual studio code set the virtual online emulator or use chrome to run this application

Architecture:
lib/
  main.dart
  models/
    lead.dart
  services/
    db_service.dart
  providers/
    lead_provider.dart
  screens/
    lead_list_screen.dart
    add_edit_lead_screen.dart
    lead_detail_screen.dart
  widgets/
    lead_list_tile.dart

Packages used:
provider: ^6.1.2
sqflite: ^2.3.0
path: ^1.9.0
path_provider: ^2.1.5

