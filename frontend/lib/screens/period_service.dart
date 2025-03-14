import 'dart:convert';
import 'package:period_tracker/screens/period_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeriodService {
  static const String _periodsKey = 'periods';

  // Save a new period
  Future<void> savePeriod(Period period) async {
    final prefs = await SharedPreferences.getInstance();
    final periods = await getPeriods();
    periods.add(period);

    final periodsJson = periods.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_periodsKey, periodsJson);
  }

  // Get all periods
  Future<List<Period>> getPeriods() async {
    final prefs = await SharedPreferences.getInstance();
    final periodsJson = prefs.getStringList(_periodsKey) ?? [];

    return periodsJson.map((p) => Period.fromJson(jsonDecode(p))).toList();
  }

  // Calculate cycle statistics
  Future<CycleStats> calculateCycleStats() async {
    final periods = await getPeriods();

    if (periods.length < 2) {
      // Default values if not enough data
      final today = DateTime.now();
      return CycleStats(
        averageCycleDays: 28,
        shortestCycle: 26,
        longestCycle: 30,
        nextPeriodStart: today.add(const Duration(days: 14)),
        nextPeriodEnd: today.add(const Duration(days: 19)),
        ovulationStart: today.add(const Duration(days: 0)),
        ovulationEnd: today.add(const Duration(days: 5)),
      );
    }

    // Sort periods by start date
    periods.sort((a, b) => a.startDate.compareTo(b.startDate));

    // Calculate cycle lengths
    List<int> cycleLengths = [];
    for (int i = 0; i < periods.length - 1; i++) {
      final currentPeriodStart = periods[i].startDate;
      final nextPeriodStart = periods[i + 1].startDate;
      final cycleLength = nextPeriodStart.difference(currentPeriodStart).inDays;
      cycleLengths.add(cycleLength);
    }

    // Calculate statistics
    final avgCycle =
        cycleLengths.reduce((a, b) => a + b) ~/ cycleLengths.length;
    final shortestCycle = cycleLengths.reduce((a, b) => a < b ? a : b);
    final longestCycle = cycleLengths.reduce((a, b) => a > b ? a : b);

    // Calculate next period
    final lastPeriod = periods.last;
    final lastPeriodDuration = lastPeriod.durationInDays;
    final nextPeriodStart = lastPeriod.startDate.add(Duration(days: avgCycle));
    final nextPeriodEnd =
        nextPeriodStart.add(Duration(days: lastPeriodDuration - 1));

    // Calculate ovulation (typically 14 days before next period)
    final ovulationDay = nextPeriodStart.subtract(const Duration(days: 14));
    final ovulationStart = ovulationDay.subtract(const Duration(days: 2));
    final ovulationEnd = ovulationDay.add(const Duration(days: 2));

    return CycleStats(
      averageCycleDays: avgCycle,
      shortestCycle: shortestCycle,
      longestCycle: longestCycle,
      nextPeriodStart: nextPeriodStart,
      nextPeriodEnd: nextPeriodEnd,
      ovulationStart: ovulationStart,
      ovulationEnd: ovulationEnd,
    );
  }
}
