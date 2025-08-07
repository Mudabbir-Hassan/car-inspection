import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/title_text.dart';
import '../widgets/progress_steps.dart';
import '../providers/inspection_provider.dart';
import 'summary_screen.dart';

class TokenTaxScreen extends StatefulWidget {
  const TokenTaxScreen({super.key});

  @override
  State<TokenTaxScreen> createState() => _TokenTaxScreenState();
}

class _TokenTaxScreenState extends State<TokenTaxScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _answers = {};
  final Map<String, TextEditingController> _controllers = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _questions = [
    {
      'key': 'tokenTax',
      'label': 'Token Tax Status',
      'icon': Icons.receipt,
      'hint': 'Enter token tax status',
    },
    {
      'key': 'challans',
      'label': 'Challan (if any)',
      'icon': Icons.warning,
      'hint': 'Enter any outstanding challans',
    },
    {
      'key': 'ciaClearance',
      'label': 'CIA (if applicable)',
      'icon': Icons.security,
      'hint': 'Enter CIA clearance status',
    },
    {
      'key': 'biometricVerification',
      'label': 'Biometric Verification',
      'icon': Icons.fingerprint,
      'hint': 'Enter biometric verification status',
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      provider.updateCurrentScreen('/legal');
      print('TokenTaxScreen: Updated current screen to /legal in initState');
    });

    for (var question in _questions) {
      _controllers[question['key']] = TextEditingController();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      _answers.addAll(provider.formAnswers);
      for (var question in _questions) {
        _controllers[question['key']]!.text = _answers[question['key']] ?? '';
      }
      provider.updateCurrentScreen('/legal');
      print('TokenTaxScreen: Updated current screen to /legal');
      print('TokenTaxScreen: Current screen is now ${provider.currentScreen}');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveData() {
    for (var question in _questions) {
      _answers[question['key']] = _controllers[question['key']]!.text;
    }
    final provider = Provider.of<InspectionProvider>(context, listen: false);
    provider.saveFormAnswers(_answers);
    provider.updateCurrentScreen('/legal');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      if (provider.currentScreen != '/legal') {
        provider.updateCurrentScreen('/legal');
        print('TokenTaxScreen: Force updated current screen to /legal');
      }
    });

    return WillPopScope(
      onWillPop: () async {
        _saveData();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Token Tax & Legal',
          showBack: true,
          actions: [
            TextButton(
              onPressed: () {
                _saveData();
                final provider =
                    Provider.of<InspectionProvider>(context, listen: false);
                provider.updateCurrentScreen('/summary');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(),
                  ),
                );
              },
              child: const Text('Skip',
                  style: TextStyle(
                      color: Color(0xFF00BFA6), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const ProgressSteps(
                    currentStep: 2,
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
                              'Tip: Legal and tax details ensure your car is clear for sale or transfer. 📝',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const TitleText('Token Tax & Legal', fontSize: 20),
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
                    label: 'Next: Instructions',
                    onPressed: () {
                      _saveData();
                      final provider = Provider.of<InspectionProvider>(context,
                          listen: false);
                      provider.updateCurrentScreen('/instructions');
                      Navigator.pushReplacementNamed(context, '/instructions');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
