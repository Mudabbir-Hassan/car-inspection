import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/title_text.dart';
import '../providers/inspection_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Welcome'),
      body: Consumer<InspectionProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: Future.delayed(const Duration(
                milliseconds: 100)), // Small delay to ensure provider is loaded
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BFA6).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/logo/hassanmotors.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Title
                    const TitleText('Hassan Motors', fontSize: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Inspection App',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Resume option if there's in-progress data
                    if (provider.hasInProgressData) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Inspection in Progress',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'You have an incomplete inspection. Would you like to resume or start over?',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    label: 'Resume',
                                    onPressed: () {
                                      // Navigate to the next screen based on current progress
                                      final nextScreen =
                                          provider.getNextScreen();
                                      Navigator.pushReplacementNamed(
                                          context, nextScreen);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // Clear data and start over
                                      provider.clearData();
                                      Navigator.pushReplacementNamed(
                                          context, '/ownership');
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      side: const BorderSide(
                                          color: Color(0xFF00BFA6)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Start Over',
                                      style: TextStyle(
                                        color: Color(0xFF00BFA6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      // Start new inspection button
                      PrimaryButton(
                        label: 'Start New Inspection',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/ownership');
                        },
                      ),
                    ],

                    const SizedBox(height: 24),

                    // App description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Professional Vehicle Inspection',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00BFA6),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complete vehicle inspection with image marking, detailed forms, and professional PDF reports.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
