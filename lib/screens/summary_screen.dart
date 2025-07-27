import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:io';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/progress_steps.dart';
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

    // Load car image
    final carImage = await _loadImage('assets/images/car-image.jpeg');

    // Page 1: Professional Header and Basic Vehicle Details
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Professional Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'HASSAN MOTORS',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    '63- Main Road Samnabad, Lahore',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'COMPREHENSIVE VEHICLE INSPECTION REPORT',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Date: ${DateTime.now().toString().split(' ')[0]}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // Basic Vehicle Details Section
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'VEHICLE DETAILS',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 15),
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
                                pw.Text(
                                  '${e.value}: ',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.grey800,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    _getAnswer(e.key, answers),
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Page 2: Legal & Tax Details
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Text(
                'LEGAL & TAX DETAILS',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                children: [
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
                                pw.Text(
                                  '${e.value}: ',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.grey800,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    _getAnswer(e.key, answers),
                                    style: pw.TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Page 3: Vehicle Condition & Inspection
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Text(
                'VEHICLE CONDITION & INSPECTION',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                children: [
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
                          ].contains(e.key))
                      .map((e) => pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 12),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  '${e.value}: ',
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.grey800,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    _getAnswer(e.key, answers),
                                    style: pw.TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Page 4: Car Images with Markings
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Text(
                'DAMAGE & PAINT MARKINGS',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // Marking Summary
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Marking Summary:',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Total marks: ${carMarks.length}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.Text(
                    'Yellow highlights: ${carMarks.where((m) => m.color == Colors.yellow).length}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Car Image with Markings
            pw.Center(
              child: _createPdfImageWithMarks('Car Image', carImage, carMarks,
                  'assets/images/car-image.jpeg'),
            ),

            pw.SizedBox(height: 30),

            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'Generated by Hassan Motors Inspection App - ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  Future<pw.MemoryImage?> _loadImage(String path) async {
    try {
      print('PDF: Loading image from path: $path');
      final data = await rootBundle.load(path);
      print(
          'PDF: Image data loaded successfully, size: ${data.lengthInBytes} bytes');
      final memoryImage = pw.MemoryImage(data.buffer.asUint8List());
      print('PDF: MemoryImage created successfully');
      return memoryImage;
    } catch (e) {
      print('PDF: Error loading image: $e');
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
          if (provider.currentScreen != '/summary') {
            provider.updateCurrentScreen('/summary');
            print('SummaryScreen: Updated current screen to /summary');
          }
        });

        return Scaffold(
          appBar: _SummaryAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Progress Steps
                const ProgressSteps(
                  currentStep: 5,
                  steps: [
                    'Ownership',
                    'Condition',
                    'Legal',
                    'Instructions',
                    'Images',
                    'Summary'
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Review your inspection:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Car Image Section
                const Text(
                  'Car Image with Markings:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _MarkedImageCard(
                      'Car Image',
                      'assets/images/car-image.jpeg',
                      _getMarksForImage(
                          'assets/images/car-image.jpeg', carMarks)),
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

    // Use a reasonable PDF size that fits on the page while maintaining aspect ratio
    final firstMark = imageMarks.isNotEmpty ? imageMarks.first : null;
    final originalWidth = firstMark?.imageWidth ?? 400.0;
    final originalHeight = firstMark?.imageHeight ?? 300.0;

    // Scale down to fit PDF page while maintaining aspect ratio
    final maxWidth = 550.0;
    final maxHeight = 580.0;
    final scaleX = maxWidth / originalWidth;
    final scaleY = maxHeight / originalHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final pdfContainerWidth = originalWidth * scale;
    final pdfContainerHeight = originalHeight * scale;

    print('PDF: Creating image for $title with ${imageMarks.length} marks');
    print('PDF: Image object: $image');
    print(
        'PDF: Container dimensions: ${pdfContainerWidth} x ${pdfContainerHeight}');
    for (var mark in imageMarks) {
      print('PDF: Mark position: ${mark.position.dx}, ${mark.position.dy}');
      print('PDF: Stored dimensions: ${mark.imageWidth} x ${mark.imageHeight}');
    }

    if (image == null) {
      return pw.Container(
        width: 400,
        height: 300,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(8),
          color: PdfColors.grey100,
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 16)),
            pw.Text('${imageMarks.length} marks',
                style: pw.TextStyle(fontSize: 14)),
          ],
        ),
      );
    }

    return pw.Container(
      width: pdfContainerWidth,
      height: pdfContainerHeight,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Stack(
        children: [
          // Use the exact same image display logic as car image screen
          pw.Center(
            child: pw.Image(
              image,
              width: pdfContainerWidth,
              height: pdfContainerHeight,
              fit: pw.BoxFit.contain,
            ),
          ),
          ...imageMarks.map((mark) {
            // Use exact same simple positioning logic as car image screen
            final scaledX = mark.position.dx * pdfContainerWidth;
            final scaledY = mark.position.dy * pdfContainerHeight;

            print(
                'PDF: Mark percentage: ${mark.position.dx}, ${mark.position.dy}');
            print(
                'PDF: Container dimensions: ${pdfContainerWidth} x ${pdfContainerHeight}');
            print('PDF: Final position: ${scaledX}, ${scaledY}');

            return pw.Positioned(
              left: scaledX - 12, // Same offset as car image screen
              top: scaledY - 12,
              child: pw.Container(
                width: 24, // Same size as car image screen
                height: 24,
                decoration: pw.BoxDecoration(
                  color: PdfColors.yellow,
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: PdfColors.black, width: 2),
                ),
              ),
            );
          }),
          // Title overlay
          pw.Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(8),
                  bottomRight: pw.Radius.circular(8),
                ),
              ),
              child: pw.Text(
                '$title (${imageMarks.length} marks)',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
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
          // Since we now only have one car image screen, always return it
          return '/car-image';
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
    // Navigate to the car image screen as a popup
    Navigator.pushNamed(
      context,
      '/car-image',
      arguments: {'isPopup': true},
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
                child: Image.asset(imagePath,
                    fit: BoxFit.cover, width: double.infinity),
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
