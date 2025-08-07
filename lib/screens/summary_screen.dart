import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

import '../widgets/primary_button.dart';
import '../widgets/progress_steps.dart';
import '../models/car_mark.dart';
import 'package:pdf/pdf.dart';
import 'package:hassan_motors_inspection/providers/inspection_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class SummaryScreen extends StatelessWidget {
  SummaryScreen({super.key});

  final Map<String, String> _allQuestions = {
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
    'challans': 'Challan (if any)',
    'tokenTax': 'Token Tax Status',
    'ciaClearance': 'CIA (if applicable)',
    'biometricVerification': 'Biometric Verification',
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

    final carImage = await _loadImage('assets/images/car-image.jpeg');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
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

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
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
            pw.SizedBox(height: 15),
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
            pw.SizedBox(height: 20),
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
            pw.SizedBox(height: 15),
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
      final data = await rootBundle.load(path);
      final memoryImage = pw.MemoryImage(data.buffer.asUint8List());
      return memoryImage;
    } catch (e) {
      return null;
    }
  }

  List<CarMark> _getMarksForImage(String imagePath, List<CarMark> carMarks) {
    return carMarks.where((mark) => mark.imagePath == imagePath).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionProvider>(
      builder: (context, provider, child) {
        final answers = provider.formAnswers;
        final carMarks = provider.carMarks;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.currentScreen != '/summary') {
            provider.updateCurrentScreen('/summary');
          }
        });

        return Scaffold(
          appBar: _SummaryAppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
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
                  const Text(
                    'Inspection Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
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

  pw.Widget _createPdfImageWithMarks(String title, pw.MemoryImage? image,
      List<CarMark> marks, String imagePath) {
    final imageMarks =
        marks.where((mark) => mark.imagePath == imagePath).toList();

    final firstMark = imageMarks.isNotEmpty ? imageMarks.first : null;
    final originalWidth = firstMark?.imageWidth ?? 400.0;
    final originalHeight = firstMark?.imageHeight ?? 300.0;

    final maxWidth = 550.0;
    final maxHeight = 580.0;
    final scaleX = maxWidth / originalWidth;
    final scaleY = maxHeight / originalHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final pdfContainerWidth = originalWidth * scale;
    final pdfContainerHeight = originalHeight * scale;

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
          pw.Center(
            child: pw.Image(
              image,
              width: pdfContainerWidth,
              height: pdfContainerHeight,
              fit: pw.BoxFit.contain,
            ),
          ),
          ...imageMarks.map((mark) {
            final scaledX = mark.position.dx * pdfContainerWidth;
            final scaledY = mark.position.dy * pdfContainerHeight;

            return pw.Positioned(
              left: scaledX - 12,
              top: scaledY - 12,
              child: pw.Container(
                width: 24,
                height: 24,
                decoration: pw.BoxDecoration(
                  color: PdfColors.yellow,
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: PdfColors.black, width: 2),
                ),
              ),
            );
          }),
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
                style: pw.TextStyle(
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

  Future<void> _generateAndPrintPdf(BuildContext context) async {
    try {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      final answers = provider.formAnswers;
      final carMarks = provider.carMarks;

      final pdfBytes = await _generatePdf(answers, carMarks);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'Hassan_Motors_Inspection_Report.pdf',
      );
    } catch (e) {
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
        String getLastCarImageScreen() {
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
