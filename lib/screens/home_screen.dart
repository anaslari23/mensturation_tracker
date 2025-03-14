import 'package:flutter/material.dart';
import '../models/cycle.dart';
import '../services/cycle_service.dart';
import '../widgets/cycle_form.dart';
import '../widgets/prediction_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Cycle> _cycles = [];
  String? _prediction;
  Map<String, dynamic>? _mlPrediction;

  Future<void> _refreshData() async {
    try {
      final cycles = await CycleService.getCycles();
      final prediction = await CycleService.getPrediction();
      final mlPrediction = await CycleService.getMLPrediction();

      setState(() {
        _cycles = cycles;
        _prediction = prediction;
        _mlPrediction = mlPrediction;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CycleForm(onSubmitted: _refreshData),
            const SizedBox(height: 20),
            PredictionView(
              prediction: _prediction,
              mlPrediction: _mlPrediction,
              cycles: _cycles,
            ),
          ],
        ),
      ),
    );
  }
}
