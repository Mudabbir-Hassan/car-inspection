import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';

import '../models/car_mark.dart';
import 'package:hassan_motors_inspection/providers/inspection_provider.dart';
import 'package:provider/provider.dart';

class CarImageScreen extends StatefulWidget {
  final String imagePath;
  final String? nextRoute;
  final String subtitle;
  final bool isPopup;
  const CarImageScreen({
    super.key,
    required this.imagePath,
    this.nextRoute,
    required this.subtitle,
    this.isPopup = false,
  });

  @override
  State<CarImageScreen> createState() => _CarImageScreenState();
}

class _CarImageScreenState extends State<CarImageScreen> {
  Color _selectedColor = Colors.yellow;
  final List<CarMark> _marks = [];

  @override
  void initState() {
    super.initState();

    // Update current screen immediately when initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InspectionProvider>(context, listen: false);
      final currentRoute =
          ModalRoute.of(context)?.settings.name ?? '/car-image';
      provider.updateCurrentScreen(currentRoute);
      print(
          'CarImageScreen: Updated current screen to $currentRoute in initState');

      // Load existing marks for this image
      final existingMarks = provider.carMarks;
      final marksForThisImage = existingMarks
          .where((mark) => mark.imagePath == widget.imagePath)
          .toList();

      setState(() {
        _marks.clear();
        _marks.addAll(marksForThisImage);
      });

      print('CarImageScreen: Loaded ${_marks.length} existing marks');
    });
  }

  void _addMark(Offset pos) {
    setState(() {
      _marks.add(CarMark(
        position: pos,
        color: _selectedColor,
        imagePath: widget.imagePath,
        viewName: widget.subtitle,
      ));
    });
  }

  void _saveData() {
    final provider = Provider.of<InspectionProvider>(context, listen: false);
    final existingMarks = provider.carMarks;

    // Remove existing marks for this image and add current marks
    final marksForOtherImages = existingMarks
        .where((mark) => mark.imagePath != widget.imagePath)
        .toList();
    final allMarks = [...marksForOtherImages, ..._marks];

    provider.saveCarMarks(allMarks);
    print(
        'CarImageScreen: Saved ${_marks.length} marks for ${widget.imagePath}');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isMediumScreen = screenSize.width < 600;

    return WillPopScope(
      onWillPop: () async {
        _saveData();
        return true;
      },
      child: Scaffold(
        appBar: widget.isPopup
            ? AppBar(
                backgroundColor: Colors.grey[800],
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () {
                    _saveData();
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  'Mark Car Image',
                  style: const TextStyle(
                    color: Color(0xFF00BFA6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              )
            : CustomAppBar(
                title: 'Mark Car Image',
                subtitle: widget.subtitle,
                showBack: true,
                actions: [
                  TextButton(
                    onPressed: () {
                      _saveData();
                      final provider = Provider.of<InspectionProvider>(context,
                          listen: false);
                      provider.updateCurrentScreen('/summary');
                      Navigator.pushReplacementNamed(context, '/summary');
                    },
                    child: const Text('Skip',
                        style: TextStyle(
                            color: Color(0xFF00BFA6),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
        body: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
          child: Column(
            children: [
              // Tool buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _HighlighterButton(
                      color: Colors.yellow,
                      label: 'Highlight',
                      selected: _selectedColor == Colors.yellow,
                      onTap: () =>
                          setState(() => _selectedColor = Colors.yellow),
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8.0 : 12.0),
                  Expanded(
                    child: _RemoveButton(
                      onTap: () {
                        if (_marks.isNotEmpty) {
                          setState(() {
                            _marks.removeLast();
                          });
                          // Save the updated marks to provider immediately
                          _saveData();
                        }
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8.0 : 12.0),
                  Expanded(
                    child: _ClearAllButton(
                      onTap: () {
                        if (_marks.isNotEmpty) {
                          setState(() {
                            _marks.clear();
                          });
                          // Save the updated marks to provider immediately
                          _saveData();
                        }
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 8.0 : 12.0),
              // Responsive image container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 8.0 : 12.0),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 8.0 : 12.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          onTapDown: (details) {
                            // Calculate exact image bounds for BoxFit.contain
                            final containerWidth = constraints.maxWidth;
                            final containerHeight = constraints.maxHeight;
                            final tapPosition = details.localPosition;

                            // Simple percentage-based positioning
                            final percentageX = tapPosition.dx / containerWidth;
                            final percentageY =
                                tapPosition.dy / containerHeight;

                            print(
                                'Tap position: ${tapPosition.dx}, ${tapPosition.dy}');
                            print(
                                'Container size: ${containerWidth} x ${containerHeight}');
                            print(
                                'Percentage position: ${percentageX}, ${percentageY}');

                            // Create mark with simple percentage positioning
                            final mark = CarMark(
                              position: Offset(percentageX, percentageY),
                              color: _selectedColor,
                              imagePath: widget.imagePath,
                              viewName: widget.subtitle,
                              imageWidth: containerWidth,
                              imageHeight: containerHeight,
                            );

                            setState(() {
                              _marks.add(mark);
                            });
                          },
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  widget.imagePath,
                                  fit: BoxFit.contain,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                ),
                              ),
                              ..._marks.map((m) {
                                // Scale mark size based on screen size
                                final markSize = isSmallScreen ? 16.0 : 24.0;
                                final offset = isSmallScreen ? 8.0 : 12.0;

                                // Simple percentage-based positioning
                                final scaledX =
                                    m.position.dx * constraints.maxWidth;
                                final scaledY =
                                    m.position.dy * constraints.maxHeight;

                                print(
                                    'Mark percentage: ${m.position.dx}, ${m.position.dy}');
                                print('Final position: ${scaledX}, ${scaledY}');

                                return Positioned(
                                  left: scaledX - offset,
                                  top: scaledY - offset,
                                  child: Container(
                                    width: markSize,
                                    height: markSize,
                                    decoration: BoxDecoration(
                                      color: m.color.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: m.color.withOpacity(0.8),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 8.0 : 12.0),
              if (widget.nextRoute != null)
                PrimaryButton(
                  label: 'Next Image',
                  onPressed: () {
                    _saveData();
                    final provider =
                        Provider.of<InspectionProvider>(context, listen: false);
                    provider.updateCurrentScreen(widget.nextRoute!);
                    Navigator.pushReplacementNamed(context, widget.nextRoute!);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlighterButton extends StatelessWidget {
  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isSmallScreen;

  const _HighlighterButton({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.0 : 18.0,
          vertical: isSmallScreen ? 8.0 : 10.0,
        ),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(isSmallScreen ? 6.0 : 8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.brush,
              color: color,
              size: isSmallScreen ? 16.0 : 20.0,
            ),
            SizedBox(width: isSmallScreen ? 4.0 : 6.0),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12.0 : 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClearAllButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSmallScreen;

  const _ClearAllButton({
    required this.onTap,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.0 : 18.0,
          vertical: isSmallScreen ? 8.0 : 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(isSmallScreen ? 6.0 : 8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear_all,
              color: Colors.orange,
              size: isSmallScreen ? 16.0 : 20.0,
            ),
            SizedBox(width: isSmallScreen ? 4.0 : 6.0),
            Text(
              'Clear All',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12.0 : 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSmallScreen;

  const _RemoveButton({
    required this.onTap,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.0 : 18.0,
          vertical: isSmallScreen ? 8.0 : 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(isSmallScreen ? 6.0 : 8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
              size: isSmallScreen ? 16.0 : 20.0,
            ),
            SizedBox(width: isSmallScreen ? 4.0 : 6.0),
            Text(
              'Remove',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12.0 : 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
