class Period {
  final DateTime startDate;
  final DateTime endDate;
  final String? description;

  Period({
    required this.startDate,
    required this.endDate,
    this.description,
  });

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
    };
  }

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
    );
  }
}

class CycleStats {
  final int averageCycleDays;
  final int shortestCycle;
  final int longestCycle;
  final DateTime nextPeriodStart;
  final DateTime nextPeriodEnd;
  final DateTime ovulationStart;
  final DateTime ovulationEnd;

  CycleStats({
    required this.averageCycleDays,
    required this.shortestCycle,
    required this.longestCycle,
    required this.nextPeriodStart,
    required this.nextPeriodEnd,
    required this.ovulationStart,
    required this.ovulationEnd,
  });

  String get nextPeriodDateRange {
    final startFormat = '${nextPeriodStart.month}/${nextPeriodStart.day}';
    final endFormat = '${nextPeriodEnd.month}/${nextPeriodEnd.day}';
    return '$startFormat - $endFormat';
  }

  String get ovulationDateRange {
    final startFormat = '${ovulationStart.month}/${ovulationStart.day}';
    final endFormat = '${ovulationEnd.month}/${ovulationEnd.day}';
    return '$startFormat - $endFormat';
  }
}
