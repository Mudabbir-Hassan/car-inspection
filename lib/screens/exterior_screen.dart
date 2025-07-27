import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/title_text.dart';
import '../widgets/progress_steps.dart';
import '../providers/inspection_provider.dart';
import 'token_tax_screen.dart';

class ExteriorScreen extends StatefulWidget {
  const ExteriorScreen({super.key});

  @override
  State<ExteriorScreen> createState() => _ExteriorScreenState();
}

class _ExteriorScreenState extends State<ExteriorScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Map<String, double> _conditionScores = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _conditionItems = [
    {
      'key': 'engineTransmissionClutch',
      'label': 'Engine / Transmission / Clutch',
      'icon': Icons.engineering,
      'description':
          'Overall condition of engine, transmission, and clutch system',
    },
    {
      'key': 'brakes',
      'label': 'Brakes',
      'icon': Icons.stop_circle,
      'description': 'Brake system condition and effectiveness',
    },
    {
      'key': 'suspensionSteering',
      'label': 'Suspension / Steering',
      'icon': Icons.directions_car,
      'description': 'Suspension and steering system condition',
    },
    {
      'key': 'interiorCondition',
      'label': 'Interior Condition',
      'icon': Icons.airline_seat_individual_suite,
      'description': 'Overall interior condition and cleanliness',
    },
    {
      'key': 'acHeater',
      'label': 'AC / Heater',
      'icon': Icons.ac_unit,
      'description': 'Air conditioning and heating system functionality',
    },
    {
      'key': 'electricalElectronics',
      'label': 'Electrical & Electronics',
      'icon': Icons.electric_bolt,
      'description': 'Electrical systems and electronic components',
    },
    {
      'key': 'exteriorBody',
      'label': 'Exterior & Body',
      'icon': Icons.directions_car_filled,
      'description': 'Exterior body condition and paint',
    },
    {
      'key': 'tyresCondition',
      'label': 'Tyres Condition',
      'icon': Icons.tire_repair,
      'description': 'Tire condition and tread depth',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();

    // Update current screen immediately when initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      provider.updateCurrentScreen('/exterior');
      print('ExteriorScreen: Updated current screen to /exterior in initState');
    });

    // Initialize all scores to 50%
    for (var item in _conditionItems) {
      _conditionScores[item['key']] = 50.0;
    }

    // Load existing data from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      final existingAnswers = provider.formAnswers;

      // Load condition scores from existing answers
      for (var item in _conditionItems) {
        final key = item['key'];
        if (existingAnswers.containsKey(key)) {
          final value = double.tryParse(existingAnswers[key] ?? '50.0') ?? 50.0;
          _conditionScores[key] = value;
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getConditionText(double value) {
    if (value >= 80) return 'Excellent';
    if (value >= 60) return 'Good';
    if (value >= 40) return 'Fair';
    if (value >= 20) return 'Poor';
    return 'Very Poor';
  }

  Color _getConditionColor(double value) {
    if (value >= 80) return Colors.green;
    if (value >= 60) return Colors.blue;
    if (value >= 40) return Colors.orange;
    if (value >= 20) return Colors.red;
    return Colors.red.shade900;
  }

  // Save data automatically when leaving the screen
  void _saveData() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      provider.saveFormAnswers(
          _conditionScores.map((k, v) => MapEntry(k, v.toString())));
      provider.updateCurrentScreen('/exterior');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure current screen is set when building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      if (provider.currentScreen != '/exterior') {
        provider.updateCurrentScreen('/exterior');
        print('ExteriorScreen: Updated current screen to /exterior');
      }
    });

    return WillPopScope(
      onWillPop: () async {
        _saveData();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Vehicle Condition & Inspection',
          showBack: true,
          actions: [
            TextButton(
              onPressed: () {
                _saveData();
                final provider =
                    Provider.of<InspectionProvider>(context, listen: false);
                provider.updateCurrentScreen('/legal');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TokenTaxScreen(),
                  ),
                );
              },
              child: const Text('Skip',
                  style: TextStyle(
                      color: Color(0xFF00BFA6), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const ProgressSteps(
                  currentStep: 1,
                  steps: [
                    'Ownership',
                    'Condition',
                    'Legal',
                    'Instructions',
                    'Images',
                    'Summary'
                  ],
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.lightbulb, color: Color(0xFF00BFA6)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Rate each component from 0% to 100%. Higher percentages indicate better condition. 🚗',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const TitleText('Vehicle Condition Assessment', fontSize: 20),
                const SizedBox(height: 16),
                ...List.generate(_conditionItems.length, (i) {
                  final item = _conditionItems[i];
                  final currentValue = _conditionScores[item['key']] ?? 50.0;

                  return FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                item['icon'],
                                color: const Color(0xFF00BFA6),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['label'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item['description'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Text(
                                '${currentValue.round()}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getConditionColor(currentValue),
                                ),
                              ),
                              Text(
                                '100%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor:
                                  _getConditionColor(currentValue),
                              inactiveTrackColor: Colors.grey[600],
                              thumbColor: _getConditionColor(currentValue),
                              overlayColor: _getConditionColor(currentValue)
                                  .withOpacity(0.2),
                              trackHeight: 6,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 12),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 24),
                            ),
                            child: Slider(
                              value: currentValue,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              onChanged: (value) {
                                setState(() {
                                  _conditionScores[item['key']] = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getConditionColor(currentValue)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: _getConditionColor(currentValue)),
                              ),
                              child: Text(
                                _getConditionText(currentValue),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getConditionColor(currentValue),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Next: Legal Details',
                  onPressed: () {
                    _saveData();
                    final provider =
                        Provider.of<InspectionProvider>(context, listen: false);
                    provider.updateCurrentScreen('/legal');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TokenTaxScreen(),
                      ),
                    );
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
