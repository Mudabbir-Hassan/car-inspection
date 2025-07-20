import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/car_mark.dart';

class InspectionProvider extends ChangeNotifier {
  Map<String, String> _formAnswers = {};
  List<CarMark> _carMarks = [];
  String _currentScreen = '/';
  bool _hasInProgressData = false;

  // Getters
  Map<String, String> get formAnswers => _formAnswers;
  List<CarMark> get carMarks => _carMarks;
  String get currentScreen => _currentScreen;
  bool get hasInProgressData => _hasInProgressData;

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
  }

  // Save form answers
  void saveFormAnswers(Map<String, String> answers) {
    _formAnswers.addAll(answers);
    _saveData();
    notifyListeners();
  }

  // Save car marks
  void saveCarMarks(List<CarMark> marks) {
    _carMarks = marks;
    _saveData();
    notifyListeners();
  }

  // Update current screen
  void updateCurrentScreen(String screen) {
    _currentScreen = screen;
    _saveData();
    notifyListeners();
  }

  // Clear all data
  void clearData() async {
    _formAnswers.clear();
    _carMarks.clear();
    _currentScreen = '/';
    _hasInProgressData = false;
    await _clearStoredData();
    notifyListeners();
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load form answers
      final answersJson = prefs.getString('form_answers');
      if (answersJson != null) {
        _formAnswers = Map<String, String>.from(json.decode(answersJson));
      }

      // Load car marks
      final marksJson = prefs.getString('car_marks');
      if (marksJson != null) {
        final marksList = json.decode(marksJson) as List;
        _carMarks = marksList.map((mark) => CarMark.fromJson(mark)).toList();
      }

      // Load current screen
      _currentScreen = prefs.getString('current_screen') ?? '/';

      // Check if there's in-progress data
      _hasInProgressData = _formAnswers.isNotEmpty || _carMarks.isNotEmpty;

      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save form answers
      await prefs.setString('form_answers', json.encode(_formAnswers));

      // Save car marks
      final marksJson = _carMarks.map((mark) => mark.toJson()).toList();
      await prefs.setString('car_marks', json.encode(marksJson));

      // Save current screen
      await prefs.setString('current_screen', _currentScreen);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Clear stored data
  Future<void> _clearStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('form_answers');
      await prefs.remove('car_marks');
      await prefs.remove('current_screen');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // Get the next screen based on current progress
  String getNextScreen() {
    // Define the flow sequence
    final flow = [
      '/ownership',
      '/exterior',
      '/legal',
      '/instructions',
      '/car-top',
      '/car-left',
      '/car-right',
      '/car-front',
      '/car-back',
      '/summary'
    ];

    // Find the current screen in the flow
    final currentIndex = flow.indexOf(_currentScreen);

    // If current screen is not found or is the last one, start from ownership
    if (currentIndex == -1 || currentIndex >= flow.length - 1) {
      return '/ownership';
    }

    // Return the next screen in the flow
    return flow[currentIndex + 1];
  }

  // Check if user has completed the inspection
  bool get isInspectionComplete {
    return _currentScreen == '/summary';
  }
}
