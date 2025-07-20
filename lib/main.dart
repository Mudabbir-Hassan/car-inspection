import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/inspection_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/instruction_screen.dart';
import 'screens/car_image_screen.dart';
import 'screens/ownership_screen.dart';
import 'screens/exterior_screen.dart';
import 'screens/token_tax_screen.dart';
import 'screens/summary_screen.dart';

void main() {
  runApp(const HassanMotorsInspectionApp());
}

class HassanMotorsInspectionApp extends StatelessWidget {
  const HassanMotorsInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = InspectionProvider();
        // Initialize the provider
        provider.initialize();
        return provider;
      },
      child: MaterialApp(
        title: 'Hassan Motors Inspection',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00BFA6),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF181A20),
          fontFamily: 'Outfit',
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF23252B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            labelStyle: const TextStyle(color: Color(0xFFB0BEC5)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA6),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF23252B),
            elevation: 4,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF00BFA6),
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'Outfit',
            ),
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/': (context) => const WelcomeScreen(),
          '/instructions': (context) => const InstructionScreen(),
          '/car-top': (context) => CarImageScreen(
                imagePath: 'assets/images/top.png',
                nextRoute: '/car-left',
                subtitle: 'Top View',
              ),
          '/car-left': (context) => CarImageScreen(
                imagePath: 'assets/images/left.png',
                nextRoute: '/car-right',
                subtitle: 'Left Side',
              ),
          '/car-right': (context) => CarImageScreen(
                imagePath: 'assets/images/right.png',
                nextRoute: '/car-front',
                subtitle: 'Right Side',
              ),
          '/car-front': (context) => CarImageScreen(
                imagePath: 'assets/images/front.png',
                nextRoute: '/car-back',
                subtitle: 'Front View',
              ),
          '/car-back': (context) => CarImageScreen(
                imagePath: 'assets/images/back.png',
                nextRoute: '/summary',
                subtitle: 'Back View',
              ),
          '/ownership': (context) => const OwnershipScreen(),
          '/exterior': (context) => const ExteriorScreen(),
          '/legal': (context) => const TokenTaxScreen(),
          '/summary': (context) => SummaryScreen(),
        },
      ),
    );
  }
}
