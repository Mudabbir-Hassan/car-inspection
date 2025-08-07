import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/car_mark.dart';

class InspectionProvider extends ChangeNotifier {
  Map<String, String> _formAnswers = {};
  List<CarMark> _carMarks = [];
  String _currentScreen = '/';
  String _previousScreen = '/';
  bool _hasInProgressData = false;

  Map<String, String> get formAnswers => _formAnswers;
  List<CarMark> get carMarks => _carMarks;
  String get currentScreen => _currentScreen;
  String get previousScreen => _previousScreen;
  bool get hasInProgressData => _hasInProgressData;

  Future<void> initialize() async {
    await _loadData();
  }

  void saveFormAnswers(Map<String, String> answers) {
    _formAnswers.addAll(answers);
    _saveData();
    notifyListeners();
  }

  void saveCarMarks(List<CarMark> marks) {
    _carMarks = marks;
    _saveData();
    notifyListeners();
  }

  void updateCurrentScreen(String screen) {
    _previousScreen = _currentScreen;
    _currentScreen = screen;
    _saveData();
    notifyListeners();
  }

  void clearData() async {
    _formAnswers.clear();
    _carMarks.clear();
    _currentScreen = '/';
    _previousScreen = '/';
    _hasInProgressData = false;
    await _clearStoredData();
    notifyListeners();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final answersJson = prefs.getString('form_answers');
      if (answersJson != null) {
        _formAnswers = Map<String, String>.from(json.decode(answersJson));
      }

      final marksJson = prefs.getString('car_marks');
      if (marksJson != null) {
        final marksList = json.decode(marksJson) as List;
        _carMarks = marksList.map((mark) => CarMark.fromJson(mark)).toList();
      }

      _currentScreen = prefs.getString('current_screen') ?? '/';
      _previousScreen = prefs.getString('previous_screen') ?? '/';

      _hasInProgressData = _formAnswers.isNotEmpty || _carMarks.isNotEmpty;

      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('form_answers', json.encode(_formAnswers));

      final marksJson = _carMarks.map((mark) => mark.toJson()).toList();
      await prefs.setString('car_marks', json.encode(marksJson));

      await prefs.setString('current_screen', _currentScreen);
      await prefs.setString('previous_screen', _previousScreen);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> _clearStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('form_answers');
      await prefs.remove('car_marks');
      await prefs.remove('current_screen');
      await prefs.remove('previous_screen');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  String getNextScreen() {
    final flow = [
      '/ownership',
      '/exterior',
      '/legal',
      '/instructions',
      '/car-image',
      '/summary'
    ];

    final currentIndex = flow.indexOf(_currentScreen);

    if (currentIndex == -1 || currentIndex >= flow.length - 1) {
      return '/ownership';
    }

    return flow[currentIndex + 1];
  }

  String getPreviousScreen() {
    final flow = [
      '/ownership',
      '/exterior',
      '/legal',
      '/instructions',
      '/car-image',
      '/summary'
    ];

    final currentIndex = flow.indexOf(_currentScreen);

    if (currentIndex == -1 || currentIndex <= 0) {
      return '/';
    }

    return flow[currentIndex - 1];
  }

  bool get isInspectionComplete {
    return _currentScreen == '/summary';
  }
}
