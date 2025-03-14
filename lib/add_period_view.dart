import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'period_tracker_model.dart';

class AddPeriodView extends StatefulWidget {
  const AddPeriodView({super.key});

  @override
  State<AddPeriodView> createState() => _AddPeriodViewState();
}

class _AddPeriodViewState extends State<AddPeriodView> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _dateFormat = DateFormat('MMM dd, yyyy');

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate == null || _endDate!.isBefore(_startDate!)) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _savePeriod() {
    if (_startDate != null && _endDate != null) {
      final model = Provider.of<PeriodTrackerModel>(context, listen: false);
      model.addPeriod(PeriodData(startDate: _startDate!, endDate: _endDate!));

      setState(() {
        _startDate = null;
        _endDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Period saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Period',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ListTile(
            title: const Text('Start Date'),
            subtitle: Text(
              _startDate != null
                  ? _dateFormat.format(_startDate!)
                  : 'Not selected',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context, true),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('End Date'),
            subtitle: Text(
              _endDate != null ? _dateFormat.format(_endDate!) : 'Not selected',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context, false),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed:
                (_startDate != null && _endDate != null) ? _savePeriod : null,
            child: const Text('Save Period'),
          ),
        ],
      ),
    );
  }
}
