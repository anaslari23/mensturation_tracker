import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/cycle_service.dart';

class CycleForm extends StatefulWidget {
  final Function() onSubmitted;

  const CycleForm({super.key, required this.onSubmitted});

  @override
  _CycleFormState createState() => _CycleFormState();
}

class _CycleFormState extends State<CycleForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String _symptoms = '';

  Future<void> _submitForm() async {
    if (_startDate == null || _endDate == null) return;

    try {
      await CycleService.addCycle(_startDate!, _endDate!, _symptoms);
      widget.onSubmitted();
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _symptoms = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: Text(_startDate == null
                    ? 'Select Start Date'
                    : 'Start: ${DateFormat.yMd().format(_startDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() => _startDate = date);
                },
              ),
              ListTile(
                title: Text(_endDate == null
                    ? 'Select End Date'
                    : 'End: ${DateFormat.yMd().format(_endDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() => _endDate = date);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Symptoms',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => _symptoms = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Cycle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
