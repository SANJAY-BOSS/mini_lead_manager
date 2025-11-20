import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/lead_provider.dart';
import 'screens/lead_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LeadProvider()..loadLeads(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Lead Manager',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // bonus: light/dark theme support
      home: const LeadListScreen(),
    );
  }
}
