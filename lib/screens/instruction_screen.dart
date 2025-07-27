import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/title_text.dart';
import '../widgets/progress_steps.dart';
import 'package:hassan_motors_inspection/providers/inspection_provider.dart';
import 'package:provider/provider.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  void initState() {
    super.initState();
    print('InstructionScreen: Initialized');

    // Update current screen immediately when initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      provider.updateCurrentScreen('/instructions');
      print(
          'InstructionScreen: Updated current screen to /instructions in initState');
    });
  }

  void _saveData(BuildContext context) {
    final provider = Provider.of<InspectionProvider>(context, listen: false);
    provider.updateCurrentScreen('/instructions');
  }

  @override
  Widget build(BuildContext context) {
    print('InstructionScreen: Building instruction screen');

    // Ensure current screen is set when building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      if (provider.currentScreen != '/instructions') {
        provider.updateCurrentScreen('/instructions');
        print('InstructionScreen: Updated current screen to /instructions');
      }
    });

    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isMediumScreen = screenSize.width < 600;

    return WillPopScope(
      onWillPop: () async {
        _saveData(context);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Instructions',
          showBack: true,
          actions: [
            TextButton(
              onPressed: () {
                _saveData(context);
                final provider =
                    Provider.of<InspectionProvider>(context, listen: false);
                provider.updateCurrentScreen('/car-image');
                Navigator.pushReplacementNamed(context, '/car-image');
              },
              child: const Text('Skip',
                  style: TextStyle(
                      color: Color(0xFF00BFA6), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  screenSize.height - 200, // Account for app bar and padding
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ProgressSteps(
                  currentStep: 3,
                  steps: [
                    'Ownership',
                    'Condition',
                    'Legal',
                    'Instructions',
                    'Images',
                    'Summary'
                  ],
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                Icon(
                  Icons.lightbulb,
                  size: isSmallScreen ? 60 : 80,
                  color: const Color(0xFF00BFA6),
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                TitleText(
                  'How to Mark Car Images',
                  fontSize: isSmallScreen ? 20 : 24,
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: Column(
                    children: [
                      _InstructionItem(
                        icon: Icons.brush,
                        color: Colors.yellow,
                        title: 'Highlight Areas',
                        description:
                            'Use the yellow highlighter to mark any areas of concern on the car image.',
                        isSmallScreen: isSmallScreen,
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      Text(
                        'Tap anywhere on the car image to place a mark. You can mark multiple areas on the image.',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 32),
                PrimaryButton(
                  label: 'Start Marking Image',
                  onPressed: () {
                    _saveData(context);
                    final provider =
                        Provider.of<InspectionProvider>(context, listen: false);
                    provider.updateCurrentScreen('/car-image');
                    Navigator.pushReplacementNamed(context, '/car-image');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final bool isSmallScreen;

  const _InstructionItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: isSmallScreen ? 20 : 24,
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
