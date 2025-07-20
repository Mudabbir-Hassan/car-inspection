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
  const CarImageScreen({
    super.key,
    required this.imagePath,
    this.nextRoute,
    required this.subtitle,
  });

  @override
  State<CarImageScreen> createState() => _CarImageScreenState();
}

class _CarImageScreenState extends State<CarImageScreen> {
  Color _selectedColor = Colors.orange;
  final List<CarMark> _marks = [];

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
    final allMarks = [...existingMarks, ..._marks];
    provider.saveCarMarks(allMarks);
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/car-top';
    provider.updateCurrentScreen(currentRoute);
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
          title: 'Mark Car Image',
          subtitle: widget.subtitle,
          showBack: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _HighlighterButton(
                    color: Colors.orange,
                    label: 'Paint',
                    selected: _selectedColor == Colors.orange,
                    onTap: () => setState(() => _selectedColor = Colors.orange),
                  ),
                  const SizedBox(width: 16),
                  _HighlighterButton(
                    color: Colors.red,
                    label: 'Accident',
                    selected: _selectedColor == Colors.red,
                    onTap: () => setState(() => _selectedColor = Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTapDown: (details) {
                        _addMark(details.localPosition);
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(widget.imagePath,
                                fit: BoxFit.contain),
                          ),
                          ..._marks.map((m) => Positioned(
                                left: m.position.dx - 12,
                                top: m.position.dy - 12,
                                child: Icon(Icons.circle,
                                    color: m.color.withOpacity(0.7), size: 24),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (widget.nextRoute != null)
                PrimaryButton(
                  label: 'Next Image',
                  onPressed: () {
                    _saveData();
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
  const _HighlighterButton(
      {required this.color,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.brush, color: color, size: 20),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
