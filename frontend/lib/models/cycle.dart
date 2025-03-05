class Cycle {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String symptoms;

  Cycle({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.symptoms,
  });

  factory Cycle.fromJson(Map<String, dynamic> json) {
    return Cycle(
      id: json['id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      symptoms: json['symptoms'],
    );
  }
}
