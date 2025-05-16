import 'package:flutter/material.dart';
import 'screens/starting_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const BCBarriersApp());
}

class BCBarriersApp extends StatelessWidget {
  const BCBarriersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barriers of BC Integration',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const StartingPage(),
    );
  }
}
