import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/title_text.dart';
import '../widgets/progress_steps.dart';
import 'package:hassan_motors_inspection/providers/inspection_provider.dart';
import 'package:provider/provider.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  void _saveData(BuildContext context) {
    final provider = Provider.of<InspectionProvider>(context, listen: false);
    provider.updateCurrentScreen('/instructions');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveData(context);
        return true;
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Instructions',
          showBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ProgressSteps(
                currentStep: 4,
                steps: [
                  'Ownership',
                  'Condition',
                  'Legal',
                  'Instructions',
                  'Images',
                  'Summary'
                ],
              ),
              const SizedBox(height: 24),
              const Icon(
                Icons.lightbulb,
                size: 80,
                color: Color(0xFF00BFA6),
              ),
              const SizedBox(height: 24),
              const TitleText('How to Mark Car Images', fontSize: 24),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: Column(
                  children: [
                    _InstructionItem(
                      icon: Icons.brush,
                      color: Colors.orange,
                      title: 'Paint Issues',
                      description:
                          'Use the orange highlighter to mark paint scratches, dents, or finish problems.',
                    ),
                    const SizedBox(height: 16),
                    _InstructionItem(
                      icon: Icons.warning,
                      color: Colors.red,
                      title: 'Accident Damage',
                      description:
                          'Use the red highlighter to mark accident damage, major dents, or structural issues.',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tap anywhere on the car image to place a mark. You can mark multiple areas on each view.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Start Marking Images',
                onPressed: () {
                  _saveData(context);
                  Navigator.pushReplacementNamed(context, '/car-top');
                },
              ),
            ],
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

  const _InstructionItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
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
