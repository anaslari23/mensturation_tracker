import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'period_tracker_model.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodTrackerModel>(
      builder: (context, model, child) {
        return ListView.builder(
          itemCount: 12, // Show 12 months
          itemBuilder: (context, index) {
            final now = DateTime.now();
            final month = DateTime(now.year, now.month - index, 1);

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('MMMM yyyy').format(month),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: _daysInMonth(month),
                    itemBuilder: (context, dayIndex) {
                      final date =
                          DateTime(month.year, month.month, dayIndex + 1);
                      final isPeriodDay = model.periods.any((period) =>
                          date.isAfter(period.startDate
                              .subtract(const Duration(days: 1))) &&
                          date.isBefore(
                              period.endDate.add(const Duration(days: 1))));

                      return Container(
                        decoration: BoxDecoration(
                          color: isPeriodDay
                              ? Theme.of(context).colorScheme.secondary
                              : null,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Text(
                            '${dayIndex + 1}',
                            style: TextStyle(
                              color: isPeriodDay ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
}
