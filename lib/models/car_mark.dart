import 'package:flutter/material.dart';

class CarMark {
  final Offset position;
  final Color color;
  final String imagePath;
  final String viewName;
  final double? imageWidth;
  final double? imageHeight;
  final double? imageOffsetX;
  final double? imageOffsetY;
  final double? imageActualWidth;
  final double? imageActualHeight;

  CarMark({
    required this.position,
    required this.color,
    required this.imagePath,
    required this.viewName,
    this.imageWidth,
    this.imageHeight,
    this.imageOffsetX,
    this.imageOffsetY,
    this.imageActualWidth,
    this.imageActualHeight,
  });

  // Get position as percentage (0.0 to 1.0)
  Offset get positionAsPercentage {
    // Use the actual position as percentage since we're now saving as percentages
    return position;
  }

  // Create mark from percentage position
  factory CarMark.fromPercentage({
    required Offset percentagePosition,
    required Color color,
    required String imagePath,
    required String viewName,
  }) {
    return CarMark(
      position: percentagePosition,
      color: color,
      imagePath: imagePath,
      viewName: viewName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': {'dx': position.dx, 'dy': position.dy},
      'color': color.value,
      'imagePath': imagePath,
      'viewName': viewName,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageOffsetX': imageOffsetX,
      'imageOffsetY': imageOffsetY,
      'imageActualWidth': imageActualWidth,
      'imageActualHeight': imageActualHeight,
    };
  }

  factory CarMark.fromJson(Map<String, dynamic> json) {
    return CarMark(
      position: Offset(json['position']['dx'], json['position']['dy']),
      color: Color(json['color']),
      imagePath: json['imagePath'],
      viewName: json['viewName'],
      imageWidth: json['imageWidth'],
      imageHeight: json['imageHeight'],
      imageOffsetX: json['imageOffsetX'],
      imageOffsetY: json['imageOffsetY'],
      imageActualWidth: json['imageActualWidth'],
      imageActualHeight: json['imageActualHeight'],
    );
  }
}

class CarInspectionData {
  final Map<String, String> formAnswers;
  final List<CarMark> carMarks;

  CarInspectionData({
    this.formAnswers = const {},
    this.carMarks = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'formAnswers': formAnswers,
      'carMarks': carMarks.map((mark) => mark.toJson()).toList(),
    };
  }

  factory CarInspectionData.fromJson(Map<String, dynamic> json) {
    return CarInspectionData(
      formAnswers: Map<String, String>.from(json['formAnswers'] ?? {}),
      carMarks: (json['carMarks'] as List?)
              ?.map((mark) => CarMark.fromJson(mark))
              .toList() ??
          [],
    );
  }
}
