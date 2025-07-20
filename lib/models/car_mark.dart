import 'package:flutter/material.dart';

class CarMark {
  final Offset position;
  final Color color;
  final String imagePath;
  final String viewName;

  CarMark({
    required this.position,
    required this.color,
    required this.imagePath,
    required this.viewName,
  });

  Map<String, dynamic> toJson() {
    return {
      'position': {'dx': position.dx, 'dy': position.dy},
      'color': color.value,
      'imagePath': imagePath,
      'viewName': viewName,
    };
  }

  factory CarMark.fromJson(Map<String, dynamic> json) {
    return CarMark(
      position: Offset(json['position']['dx'], json['position']['dy']),
      color: Color(json['color']),
      imagePath: json['imagePath'],
      viewName: json['viewName'],
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
