import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PeriodData {
  final DateTime startDate;
  final DateTime endDate;

  PeriodData({required this.startDate, required this.endDate});

  Map<String, dynamic> toJson() => {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

class PeriodTrackerModel extends ChangeNotifier {
  List<PeriodData> _periods = [];

  List<PeriodData> get periods => _periods;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? periodsJson = prefs.getString('periods');
    if (periodsJson != null) {
      final List<dynamic> decodedList = json.decode(periodsJson);
      _periods = decodedList.map((item) => PeriodData.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> addPeriod(PeriodData period) async {
    _periods.add(period);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'periods', json.encode(_periods.map((p) => p.toJson()).toList()));
    notifyListeners();
  }

  double getAverageCycleLength() {
    if (_periods.length < 2) return 28; // Default cycle length

    int totalDays = 0;
    for (int i = 0; i < _periods.length - 1; i++) {
      totalDays +=
          _periods[i + 1].startDate.difference(_periods[i].startDate).inDays;
    }
    return totalDays / (_periods.length - 1);
  }

  double getAveragePeriodLength() {
    if (_periods.isEmpty) return 5; // Default period length

    int totalDays = 0;
    for (var period in _periods) {
      totalDays += period.endDate.difference(period.startDate).inDays + 1;
    }
    return totalDays / _periods.length;
  }
}
