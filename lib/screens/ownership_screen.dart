import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/title_text.dart';
import '../widgets/progress_steps.dart';
import '../providers/inspection_provider.dart';
import 'exterior_screen.dart';

class OwnershipScreen extends StatefulWidget {
  const OwnershipScreen({super.key});

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _answers = {};
  final Map<String, TextEditingController> _controllers = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _questions = [
    {
      'key': 'ownerName',
      'label': 'Owner Name',
      'icon': Icons.person,
      'hint': 'Enter owner\'s full name',
    },
    {
      'key': 'contact',
      'label': 'Contact Number',
      'icon': Icons.phone,
      'hint': 'Enter contact number',
    },
    {
      'key': 'cnic',
      'label': 'CNIC Number',
      'icon': Icons.badge,
      'hint': 'Enter CNIC number',
    },
    {
      'key': 'yearManufacturing',
      'label': 'Year of Manufacturing',
      'icon': Icons.calendar_today,
      'hint': 'Enter manufacturing year',
    },
    {
      'key': 'yearImport',
      'label': 'Year of Import',
      'icon': Icons.import_export,
      'hint': 'Enter import year',
    },
    {
      'key': 'yearRegistration',
      'label': 'Year of Registration',
      'icon': Icons.how_to_reg,
      'hint': 'Enter registration year',
    },
    {
      'key': 'make',
      'label': 'Make',
      'icon': Icons.directions_car,
      'hint': 'Enter vehicle make',
    },
    {
      'key': 'model',
      'label': 'Model',
      'icon': Icons.directions_car_filled,
      'hint': 'Enter vehicle model',
    },
    {
      'key': 'type',
      'label': 'Type',
      'icon': Icons.category,
      'hint': 'Enter vehicle type',
    },
    {
      'key': 'carName',
      'label': 'Car Name',
      'icon': Icons.label,
      'hint': 'Enter car name',
    },
    {
      'key': 'customerDealerName',
      'label': 'Customer/Dealer Name',
      'icon': Icons.business,
      'hint': 'Enter customer or dealer name',
    },
    {
      'key': 'engineCapacity',
      'label': 'Engine Capacity',
      'icon': Icons.speed,
      'hint': 'Enter engine capacity (cc)',
    },
    {
      'key': 'mileage',
      'label': 'Mileage',
      'icon': Icons.speed,
      'hint': 'Enter current mileage',
    },
    {
      'key': 'fuelType',
      'label': 'Fuel Type',
      'icon': Icons.local_gas_station,
      'hint': 'Petrol/Diesel/Hybrid/etc.',
    },
    {
      'key': 'inspectionDate',
      'label': 'Inspection Date',
      'icon': Icons.calendar_month,
      'hint': 'Enter inspection date',
    },
    {
      'key': 'chassis',
      'label': 'Chassis Number',
      'icon': Icons.numbers,
      'hint': 'Enter chassis number',
    },
    {
      'key': 'engine',
      'label': 'Engine Number',
      'icon': Icons.engineering,
      'hint': 'Enter engine number',
    },
    {
      'key': 'registration',
      'label': 'Registration Number',
      'icon': Icons.confirmation_number,
      'hint': 'Enter registration number',
    },
    {
      'key': 'previousOwners',
      'label': 'Number of Previous Owners',
      'icon': Icons.people,
      'hint': 'Enter number of previous owners',
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

    // Initialize controllers for each field
    for (var question in _questions) {
      _controllers[question['key']] = TextEditingController();
    }

    // Load existing data from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      _answers.addAll(provider.formAnswers);
      // Set initial values for controllers
      for (var question in _questions) {
        _controllers[question['key']]!.text = _answers[question['key']] ?? '';
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Save data automatically when leaving the screen
  void _saveData() {
    // Get values from controllers
    for (var question in _questions) {
      _answers[question['key']] = _controllers[question['key']]!.text;
    }
    final provider = Provider.of<InspectionProvider>(context, listen: false);
    provider.saveFormAnswers(_answers);
    provider.updateCurrentScreen('/ownership');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveData();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Ownership Details',
          showBack: true,
          actions: [
            TextButton(
              onPressed: () {
                _saveData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExteriorScreen(),
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
                            'Tip: Accurate ownership details help us generate a more reliable inspection report. 🚗',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const TitleText('Ownership Details', fontSize: 20),
                const SizedBox(height: 16),
                ...List.generate(_questions.length, (i) {
                  return FadeTransition(
                    opacity: _fadeAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _controllers[_questions[i]['key']],
                        decoration: InputDecoration(
                          labelText: _questions[i]['label'],
                          prefixIcon: Icon(_questions[i]['icon'],
                              color: Theme.of(context).colorScheme.secondary),
                          hintText: _questions[i]['hint'],
                          helperText: _questions[i]['hint'],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Next: Vehicle Condition & Inspection',
                  onPressed: () {
                    _saveData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExteriorScreen(),
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
