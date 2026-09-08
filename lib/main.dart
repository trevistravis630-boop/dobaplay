import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uuvjbzhgwgunapwewami.supabase.co',
    publishableKey: 'sb_publishable_aSNXYyz0cjmcvk9jwXRw7w_WvwsueyK',
  );

  runApp(const Dobapp());
}

class Dobapp extends StatelessWidget {
  const Dobapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dobaplay',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}