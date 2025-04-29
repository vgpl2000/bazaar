import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BazaarApp());
}

class BazaarApp extends StatelessWidget {
  const BazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
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
            color: const Color(0xFF212121),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          navLargeTitleTextStyle: GoogleFonts.farro(
            color: const Color(0xFF212121),
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Bazaar'),
        backgroundColor: Color(0xFF2E7D32), // Teal Blue
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive font size and padding
            final fontSize = constraints.maxWidth > 600 ? 32.0 : 24.0;
            final padding = constraints.maxWidth > 600 ? 32.0 : 16.0;

            return Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  'Welcome to Bazaar',
                  style: GoogleFonts.farro(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700, // Farro Bold
                    color: const Color(0xFF2E7D32), // Teal Blue
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}