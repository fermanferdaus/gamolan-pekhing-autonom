import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'theme/lampung_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GamolanApp());
}

class GamolanApp extends StatelessWidget {
  const GamolanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamolan Pekhing',
      debugShowCheckedModeBanner: false,
      theme: LampungTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
