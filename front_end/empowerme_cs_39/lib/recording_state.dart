import 'package:flutter/cupertino.dart';

class RecordingState with ChangeNotifier {
  int _selectedIndex = 0;
  bool _isRecording = false;

  int get selectedIndex => _selectedIndex;
  bool get isRecording => _isRecording;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void toggleRecording() {
    _isRecording = !_isRecording;
    notifyListeners();
  }
}