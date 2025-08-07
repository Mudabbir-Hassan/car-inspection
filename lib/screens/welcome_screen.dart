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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isMediumScreen = screenSize.width < 600;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Welcome'),
      body: Consumer<InspectionProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 100)),
            builder: (context, snapshot) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo
                              Container(
                                width: isSmallScreen ? 100 : 120,
                                height: isSmallScreen ? 100 : 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 16 : 20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00BFA6)
                                          .withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 16 : 20),
                                  child: Image.asset(
                                    'assets/logo/hassanmotors.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 24 : 32),

                              // App Title
                              TitleText(
                                'Hassan Motors',
                                fontSize: isSmallScreen ? 28 : 32,
                              ),
                              SizedBox(height: isSmallScreen ? 6 : 8),
                              Text(
                                'Inspection App',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  color: Colors.grey,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 32 : 48),

                              if (provider.hasInProgressData) ...[
                                Container(
                                  padding:
                                      EdgeInsets.all(isSmallScreen ? 12 : 16),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 8 : 12),
                                    border: Border.all(
                                        color: Colors.orange.withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Colors.orange,
                                            size: isSmallScreen ? 18 : 20,
                                          ),
                                          SizedBox(
                                              width: isSmallScreen ? 6 : 8),
                                          Expanded(
                                            child: Text(
                                              'Inspection in Progress',
                                              style: TextStyle(
                                                fontSize:
                                                    isSmallScreen ? 14 : 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: isSmallScreen ? 8 : 12),
                                      Text(
                                        'You have an incomplete inspection. Would you like to resume or start over?',
                                        style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: isSmallScreen ? 12 : 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: PrimaryButton(
                                              label: 'Resume',
                                              onPressed: () {
                                                final nextScreen =
                                                    provider.getNextScreen();
                                                provider.updateCurrentScreen(
                                                    nextScreen);
                                                Navigator.pushReplacementNamed(
                                                    context, nextScreen);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                              width: isSmallScreen ? 8 : 12),
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                provider.clearData();
                                                Navigator.pushReplacementNamed(
                                                    context, '/ownership');
                                              },
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      isSmallScreen ? 12 : 16,
                                                ),
                                                side: const BorderSide(
                                                    color: Color(0xFF00BFA6)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          isSmallScreen
                                                              ? 8
                                                              : 12),
                                                ),
                                              ),
                                              child: Text(
                                                'Start Over',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF00BFA6),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      isSmallScreen ? 14 : 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 24),
                              ] else ...[
                                PrimaryButton(
                                  label: 'Start New Inspection',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/ownership');
                                  },
                                ),
                              ],

                              SizedBox(height: isSmallScreen ? 16 : 24),

                              Container(
                                padding:
                                    EdgeInsets.all(isSmallScreen ? 12 : 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 8 : 12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Professional Vehicle Inspection',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF00BFA6),
                                      ),
                                    ),
                                    SizedBox(height: isSmallScreen ? 6 : 8),
                                    Text(
                                      'Complete vehicle inspection with image marking, detailed forms, and professional PDF reports.',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
