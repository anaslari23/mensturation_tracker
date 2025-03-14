import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'period_tracker_model.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodTrackerModel>(
      builder: (context, model, child) {
        final averageCycle = model.getAverageCycleLength();
        final averagePeriod = model.getAveragePeriodLength();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your Period Insights',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildInsightCard(
                context,
                'Average Cycle Length',
                '${averageCycle.toStringAsFixed(1)} days',
                'Time between the start of one period and the start of the next',
                Icons.autorenew,
              ),
              const SizedBox(height: 16),
              _buildInsightCard(
                context,
                'Average Period Length',
                '${averagePeriod.toStringAsFixed(1)} days',
                'Duration of your period',
                Icons.calendar_today,
              ),
              const SizedBox(height: 16),
              _buildInsightCard(
                context,
                'Tracked Periods',
                '${model.periods.length}',
                'Number of periods you have tracked',
                Icons.track_changes,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightCard(BuildContext context, String title, String value,
      String description, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
