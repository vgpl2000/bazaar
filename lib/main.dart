import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bazaar/presentation/screens/product_list_screen.dart';

void main() {
  runApp(const BazaarApp());
}

class BazaarApp extends StatelessWidget {
  const BazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Bazaar',
      theme: CupertinoThemeData(
        primaryColor: const Color(0xFF2E7D32), // Teal Blue
        scaffoldBackgroundColor: const Color(0xFFB0BEC5), // Warm Gray
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.farro(
            color: const Color(0xFF212121), // Deep Charcoal
            fontSize: 17,
          ),
          navTitleTextStyle: GoogleFonts.farro(
            color: const Color(0xFF212121), // Deep Charcoal
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          navLargeTitleTextStyle: GoogleFonts.farro(
            color: const Color(0xFF212121), // Deep Charcoal
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
          navActionTextStyle: GoogleFonts.farro(
            color: const Color(0xFF2E7D32), // Teal Blue
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          actionTextStyle: GoogleFonts.farro(
            color: const Color(0xFF2E7D32), // Teal Blue
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const ProductListScreen(),
    );
  }
}