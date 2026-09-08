import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const Dobapp());
}

class Dobapp extends StatelessWidget {
  const Dobapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dobapp',
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: Text(
            'DOBAPLAY',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}