import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'period_tracker_model.dart';
import 'add_period_view.dart';
import 'calender_view.dart';
import 'insights_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => PeriodTrackerModel(),
      child: const PeriodTrackerApp(),
    ),
  );
}

class PeriodTrackerApp extends StatelessWidget {
  const PeriodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: const Color(0xFFE57373),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE57373),
          primary: const Color(0xFFE57373),
          secondary: const Color(0xFFF8BBD0),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE57373),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PeriodTrackerModel>(context, listen: false).loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today), text: 'Calendar'),
            Tab(icon: Icon(Icons.add_circle_outline), text: 'Add Period'),
            Tab(icon: Icon(Icons.insights), text: 'Insights'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CalendarView(),
          AddPeriodView(),
          InsightsView(),
        ],
      ),
    );
  }
}
