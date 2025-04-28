import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BazaarApp());
}

class BazaarApp extends StatelessWidget {
  const BazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bazaar',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32), // Teal Blue
        scaffoldBackgroundColor: const Color(0xFFB0BEC5), // Warm Gray
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2E7D32), // Teal Blue
          secondary: Color(0xFFB0BEC5), // Warm Gray
        ),
        textTheme: GoogleFonts.farroTextTheme(
          Theme.of(context).textTheme.copyWith(
            bodyLarge: const TextStyle(color: Color(0xFF212121)), // Deep Charcoal
            bodyMedium: const TextStyle(color: Color(0xFF757575)), // Slate Gray
          ),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Welcome to Bazaar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700, // Farro Bold
              color: Color(0xFF2E7D32), // Teal Blue
            ),
          ),
        ),
      ),
    );
  }
}