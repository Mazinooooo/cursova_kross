import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/foundation.dart'; // Для перевірки платформи
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Для платформ, де FFI підтримується
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Для вебу

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/history_screen.dart';

void main() {
  // Ініціалізація залежно від платформи
  if (kIsWeb) {
    // Для вебу
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // Для мобільних пристроїв та десктопів
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Калькулятор',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/calculator': (context) => CalculatorScreen(),
        '/history': (context) => HistoryScreen(),
      },
    );
  }
}
