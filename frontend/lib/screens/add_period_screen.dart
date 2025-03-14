import 'package:flutter/material.dart';
import '../main.dart';

class AddPeriodView extends StatelessWidget {
  const AddPeriodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Period'),
      ),
      body: const Center(
        child: Text('Add Period View'),
      ),
    );
  }
}
