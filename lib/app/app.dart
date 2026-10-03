import 'package:flutter/material.dart';
import 'package:runmares/app/theme/app_theme.dart';

class RunMaresApp extends StatelessWidget {
  const RunMaresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunMares',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(body: Center(child: Text('RunMares'))),
    );
  }
}
