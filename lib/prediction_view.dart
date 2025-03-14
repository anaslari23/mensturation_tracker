import 'package:flutter/material.dart';

class PredictionView extends StatelessWidget {
  final String? prediction;
  final String error;

  const PredictionView({super.key, this.prediction, required this.error});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Next Predicted Period',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red))
            else
              Text(prediction ?? 'No prediction available',
                  style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
