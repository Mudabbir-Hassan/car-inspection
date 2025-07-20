import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:io';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../models/car_mark.dart';
import 'dart:ui'; // Added for BackdropFilter
import 'package:pdf/pdf.dart'; // Added for PdfColors
import 'package:pdf/pdf.dart'; // Added for PdfPageFormat
import 'package:hassan_motors_inspection/providers/inspection_provider.dart'; // Added for InspectionProvider
import 'package:provider/provider.dart'; // Added for Provider
import 'package:flutter/services.dart' show rootBundle; // Added for _loadImage

class SummaryScreen extends StatelessWidget {
  SummaryScreen({super.key});

  // Define all possible questions from the inspection flow
  final Map<String, String> _allQuestions = {
    // Basic Vehicle Details
    'ownerName': 'Owner Name',
    'contact': 'Contact Number',
    'cnic': 'CNIC Number',
    'yearManufacturing': 'Year of Manufacturing',
    'yearImport': 'Year of Import',
    'yearRegistration': 'Year of Registration',
    'make': 'Make',
    'model': 'Model',
    'type': 'Type',
    'carName': 'Car Name',
    'customerDealerName': 'Customer/Dealer Name',
    'engineCapacity': 'Engine Capacity',
    'mileage': 'Mileage',
    'fuelType': 'Fuel Type',
    'inspectionDate': 'Inspection Date',
    'chassis': 'Chassis Number',
    'engine': 'Engine Number',
    'registration': 'Registration Number',
    'previousOwners': 'Number of Previous Owners',

    // Legal & Tax Details
    'challans': 'Challan (if any)',
    'tokenTax': 'Token Tax Status',
    'ciaClearance': 'CIA (if applicable)',
    'biometricVerification': 'Biometric Verification',

    // Vehicle Condition & Inspection
    'engineTransmissionClutch': 'Engine / Transmission / Clutch',
    'brakes': 'Brakes',
    'suspensionSteering': 'Suspension / Steering',
    'interiorCondition': 'Interior Condition',
    'acHeater': 'AC / Heater',
    'electricalElectronics': 'Electrical & Electronics',
    'exteriorBody': 'Exterior & Body',
    'tyresCondition': 'Tyres Condition',
  };

  String _getAnswer(String key, Map<String, String> answers) {
    return answers[key]?.isNotEmpty == true ? answers[key]! : 'N/A';
  }

  Future<Uint8List> _generatePdf(
      Map<String, String> answers, List<CarMark> carMarks) async {
    final pdf = pw.Document();

    // Load car images
    final topImage = await _loadImage('assets/images/top.png');
    final leftImage = await _loadImage('assets/images/left.png');
    final rightImage = await _loadImage('assets/images/right.png');
    final frontImage = await _loadImage('assets/images/front.png');
    final backImage = await _loadImage('assets/images/back.png');

    // Page 1: Header and Basic Vehicle Details
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Text('Hassan Motors', style: pw.TextStyle(fontSize: 24)),
            pw.Text('Vehicle Inspection Report',
                style: pw.TextStyle(fontSize: 16)),
            pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 30),

            // Title
            pw.Center(
              child: pw.Text(
                'COMPREHENSIVE VEHICLE INSPECTION REPORT',
                style: pw.TextStyle(fontSize: 20),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 30),

            // Basic Vehicle Details
            pw.Text('Basic Vehicle Details', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            ..._allQuestions.entries
                .where((e) => [
                      'ownerName',
                      'contact',
                      'cnic',
                      'yearManufacturing',
                      'yearImport',
                      'yearRegistration',
                      'make',
                      'model',
                      'type',
                      'carName',
                      'customerDealerName',
                      'engineCapacity',
                      'mileage',
                      'fuelType',
                      'inspectionDate',
                      'chassis',
                      'engine',
                      'registration',
                      'previousOwners'
                    ].contains(e.key))
                .map((e) => pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('${e.value}: ',
                              style: pw.TextStyle(fontSize: 12)),
                          pw.Expanded(
                            child: pw.Text(_getAnswer(e.key, answers),
                                style: pw.TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );

    // Page 2: Legal & Tax Details
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Legal & Tax Details', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            ..._allQuestions.entries
                .where((e) => [
                      'challans',
                      'tokenTax',
                      'ciaClearance',
                      'biometricVerification'
                    ].contains(e.key))
                .map((e) => pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 12),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('${e.value}: ',
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Expanded(
                            child: pw.Text(_getAnswer(e.key, answers),
                                style: pw.TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );

    // Page 3: Vehicle Condition & Inspection
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Vehicle Condition & Inspection',
                style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            ..._allQuestions.entries
                .where((e) => [
                      'engineTransmissionClutch',
                      'brakes',
                      'suspensionSteering',
                      'interiorCondition',
                      'acHeater',
                      'electricalElectronics',
                      'exteriorBody',
                      'tyresCondition'
                    ].contains((e) => e.key))
                .map((e) => pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 12),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('${e.value}: ',
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Expanded(
                            child: pw.Text(_getAnswer(e.key, answers),
                                style: pw.TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );

    // Page 4: Car Images with Markings
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Painted Areas and Damage Markings',
                style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            pw.Text('Marking Summary:', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            pw.Text('Total marks: ${carMarks.length}',
                style: pw.TextStyle(fontSize: 14)),
            pw.Text(
                'Paint issues: ${carMarks.where((m) => m.color == Colors.orange).length}',
                style: pw.TextStyle(fontSize: 14)),
            pw.Text(
                'Accident damage: ${carMarks.where((m) => m.color == Colors.red).length}',
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),

            // Car Images Grid
            pw.Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _createPdfImageWithMarks(
                    'Top View', topImage, carMarks, 'assets/images/top.png'),
                _createPdfImageWithMarks(
                    'Left Side', leftImage, carMarks, 'assets/images/left.png'),
                _createPdfImageWithMarks('Right Side', rightImage, carMarks,
                    'assets/images/right.png'),
                _createPdfImageWithMarks('Front View', frontImage, carMarks,
                    'assets/images/front.png'),
                _createPdfImageWithMarks(
                    'Back View', backImage, carMarks, 'assets/images/back.png'),
              ],
            ),

            pw.SizedBox(height: 30),
            pw.Text('Generated by Hassan Motors Inspection App',
                style: pw.TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  Future<pw.MemoryImage?> _loadImage(String path) async {
    try {
      final data = await rootBundle.load(path);
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      return null;
    }
  }

  List<CarMark> _getMarksForImage(String imagePath, List<CarMark> carMarks) {
    final marks =
        carMarks.where((mark) => mark.imagePath == imagePath).toList();
    for (var mark in marks) {}
    return marks;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionProvider>(
      builder: (context, provider, child) {
        final answers = provider.formAnswers;
        final carMarks = provider.carMarks;

        // Update current screen to summary when reaching this screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.updateCurrentScreen('/summary');
        });

        return Scaffold(
          appBar: _SummaryAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  'Review your inspection:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Car Images Section
                const Text(
                  'Car Images with Markings:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _MarkedImageCard('Top View', 'assets/images/top.png',
                          _getMarksForImage('assets/images/top.png', carMarks)),
                      const SizedBox(width: 12),
                      _MarkedImageCard(
                          'Left Side',
                          'assets/images/left.png',
                          _getMarksForImage(
                              'assets/images/left.png', carMarks)),
                      const SizedBox(width: 12),
                      _MarkedImageCard(
                          'Right Side',
                          'assets/images/right.png',
                          _getMarksForImage(
                              'assets/images/right.png', carMarks)),
                      const SizedBox(width: 12),
                      _MarkedImageCard(
                          'Front View',
                          'assets/images/front.png',
                          _getMarksForImage(
                              'assets/images/front.png', carMarks)),
                      const SizedBox(width: 12),
                      _MarkedImageCard(
                          'Back View',
                          'assets/images/back.png',
                          _getMarksForImage(
                              'assets/images/back.png', carMarks)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form Answers Section
                const Text(
                  'Inspection Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Basic Vehicle Details Section
                _buildSection(
                    'Basic Vehicle Details',
                    {
                      'ownerName': 'Owner Name',
                      'contact': 'Contact Number',
                      'cnic': 'CNIC Number',
                      'yearManufacturing': 'Year of Manufacturing',
                      'yearImport': 'Year of Import',
                      'yearRegistration': 'Year of Registration',
                      'make': 'Make',
                      'model': 'Model',
                      'type': 'Type',
                      'carName': 'Car Name',
                      'customerDealerName': 'Customer/Dealer Name',
                      'engineCapacity': 'Engine Capacity',
                      'mileage': 'Mileage',
                      'fuelType': 'Fuel Type',
                      'inspectionDate': 'Inspection Date',
                      'chassis': 'Chassis Number',
                      'engine': 'Engine Number',
                      'registration': 'Registration Number',
                      'previousOwners': 'Number of Previous Owners',
                    },
                    answers),

                const SizedBox(height: 16),

                // Legal & Tax Details Section
                _buildSection(
                    'Legal & Tax Details',
                    {
                      'challans': 'Challan (if any)',
                      'tokenTax': 'Token Tax Status',
                      'ciaClearance': 'CIA (if applicable)',
                      'biometricVerification': 'Biometric Verification',
                    },
                    answers),

                const SizedBox(height: 16),

                // Vehicle Condition & Inspection Section
                _buildSection(
                    'Vehicle Condition & Inspection',
                    {
                      'engineTransmissionClutch':
                          'Engine / Transmission / Clutch',
                      'brakes': 'Brakes',
                      'suspensionSteering': 'Suspension / Steering',
                      'interiorCondition': 'Interior Condition',
                      'acHeater': 'AC / Heater',
                      'electricalElectronics': 'Electrical & Electronics',
                      'exteriorBody': 'Exterior & Body',
                      'tyresCondition': 'Tyres Condition',
                    },
                    answers),

                const SizedBox(height: 24),

                PrimaryButton(
                  label: 'Generate PDF Report',
                  onPressed: () async {
                    await _generateAndPrintPdf(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, Map<String, String> questions,
      Map<String, String> answers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BFA6)),
        ),
        const SizedBox(height: 8),
        ...questions.entries.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${e.value}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_getAnswer(e.key, answers))),
                ],
              ),
            )),
      ],
    );
  }

  pw.Widget _buildPdfSection(String title, Map<String, String> questions,
      Map<String, String> answers) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...questions.entries.map((e) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${e.value}:',
                    style: const pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.Text(
                      _getAnswer(e.key, answers),
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  pw.Widget _createPdfImageWithMarks(String title, pw.MemoryImage? image,
      List<CarMark> marks, String imagePath) {
    final imageMarks =
        marks.where((mark) => mark.imagePath == imagePath).toList();

    if (image == null) {
      return pw.Container(
        width: 150,
        height: 120,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(8),
          color: PdfColors.grey100,
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 12)),
            pw.Text('${imageMarks.length} marks',
                style: pw.TextStyle(fontSize: 10)),
          ],
        ),
      );
    }

    return pw.Container(
      width: 150,
      height: 120,
      child: pw.Stack(
        children: [
          pw.Image(image),
          ...imageMarks.map((mark) => pw.Positioned(
                left: mark.position.dx - 5,
                top: mark.position.dy - 5,
                child: pw.Container(
                  width: 10,
                  height: 10,
                  decoration: pw.BoxDecoration(
                    color: mark.color == Colors.red
                        ? PdfColors.red
                        : PdfColors.orange,
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.white, width: 1),
                  ),
                ),
              )),
          pw.Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(4),
              color: PdfColors.grey800,
              child: pw.Text(
                '$title (${imageMarks.length} marks)',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _createImagePlaceholder(String title, List<CarMark> marks) {
    return pw.Container(
      width: 200,
      height: 150,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey100,
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.teal,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${marks.length} marks',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndPrintPdf(BuildContext context) async {
    try {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      final answers = provider.formAnswers;
      final carMarks = provider.carMarks;

      // Generate PDF on main thread
      final pdfBytes = await _generatePdf(answers, carMarks);

      // Print PDF using proper threading
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'Hassan_Motors_Inspection_Report.pdf',
      );
    } catch (e) {
      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to generate PDF: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}

class _SummaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionProvider>(
      builder: (context, provider, child) {
        // Determine the last car image screen based on current progress
        String getLastCarImageScreen() {
          final carScreens = [
            '/car-top',
            '/car-left',
            '/car-right',
            '/car-front',
            '/car-back'
          ];
          final currentScreen = provider.currentScreen;

          // If current screen is a car screen, go back one step
          final currentIndex = carScreens.indexOf(currentScreen);
          if (currentIndex > 0) {
            return carScreens[currentIndex - 1];
          }

          // Default to car-back if no specific car screen found
          return '/car-back';
        }

        return Material(
          elevation: 8,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(24)),
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF00BFA6)),
                onPressed: () {
                  // Navigate back to the last car image screen
                  final lastCarScreen = getLastCarImageScreen();
                  Navigator.pushReplacementNamed(context, lastCarScreen);
                },
              ),
              title: const Column(
                children: [
                  Text('Inspection Summary'),
                ],
              ),
              centerTitle: true,
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _MarkedImageCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final List<CarMark> marks;

  const _MarkedImageCard(this.title, this.imagePath, this.marks);

  void _showImagePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00BFA6),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // Image with pinpoints
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[600]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                ...marks.map((mark) {
                                  // Calculate the scaled position based on actual image dimensions
                                  // Get the actual image size from the asset
                                  final imageWidth =
                                      300.0; // Approximate original image width
                                  final imageHeight =
                                      200.0; // Approximate original image height

                                  // Calculate the scale factors based on the actual container constraints
                                  final scaleX =
                                      constraints.maxWidth / imageWidth;
                                  final scaleY =
                                      constraints.maxHeight / imageHeight;

                                  // Use the smaller scale to maintain aspect ratio
                                  final scale =
                                      scaleX < scaleY ? scaleX : scaleY;

                                  // Calculate the scaled position
                                  final scaledX = mark.position.dx * scale;
                                  final scaledY = mark.position.dy * scale;

                                  // Center the image if needed
                                  final imageOffsetX = (constraints.maxWidth -
                                          (imageWidth * scale)) /
                                      2;
                                  final imageOffsetY = (constraints.maxHeight -
                                          (imageHeight * scale)) /
                                      2;

                                  return Positioned(
                                    left: imageOffsetX + scaledX - 12,
                                    top: imageOffsetY + scaledY - 12,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: mark.color.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Legend
                  if (marks.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Markings: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...marks.map((mark) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: mark.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: mark.color),
                                ),
                                child: Text(
                                  mark.color == Colors.red
                                      ? 'Accident'
                                      : 'Paint',
                                  style: TextStyle(
                                    color: mark.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePopup(context),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[600]!),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                child: Stack(
                  children: [
                    Image.asset(imagePath,
                        fit: BoxFit.cover, width: double.infinity),
                    ...marks.map((mark) {
                      // Calculate the scaled position for the small card
                      final cardWidth = 100.0;
                      final cardHeight =
                          80.0; // Approximate height of the image area
                      final imageWidth = 300.0; // Original image width
                      final imageHeight = 200.0; // Original image height

                      // Calculate scale for the small card
                      final scaleX = cardWidth / imageWidth;
                      final scaleY = cardHeight / imageHeight;
                      final scale = scaleX < scaleY ? scaleX : scaleY;

                      // Calculate the scaled position
                      final scaledX = mark.position.dx * scale;
                      final scaledY = mark.position.dy * scale;

                      // Center the image if needed
                      final imageOffsetX =
                          (cardWidth - (imageWidth * scale)) / 2;
                      final imageOffsetY =
                          (cardHeight - (imageHeight * scale)) / 2;

                      return Positioned(
                        left: imageOffsetX +
                            scaledX -
                            8, // Smaller offset for small card
                        top: imageOffsetY + scaledY - 8,
                        child: Container(
                          width: 16, // Smaller size for small card
                          height: 16,
                          decoration: BoxDecoration(
                            color: mark.color.withOpacity(0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
