import 'package:flutter/material.dart';
import '../models/cycle.dart';

class PredictionView extends StatelessWidget {
  final String? prediction;
  final Map<String, dynamic>? mlPrediction;
  final List<Cycle> cycles;

  const PredictionView({
    super.key,
    this.prediction,
    this.mlPrediction,
    required this.cycles,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cycle History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...cycles
                .map((cycle) => ListTile(
                      title: Text('${cycle.startDate} to ${cycle.endDate}'),
                      subtitle: Text(
                          '${(cycle.endDate.difference(cycle.startDate).inDays)} days'),
                    ))
                ,
            const Divider(),
            if (prediction != null) ...[
              const Text('Basic Prediction',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Next period: $prediction'),
            ],
            if (mlPrediction != null) ...[
              const SizedBox(height: 10),
              const Text('AI Prediction',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                  'Expected cycle length: ${mlPrediction!['prediction']} days'),
              Text(
                  'Confidence: ${(mlPrediction!['confidence'] * 100).toStringAsFixed(1)}%'),
            ],
          ],
        ),
      ),
    );
  }
}
