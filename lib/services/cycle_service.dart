import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cycle.dart';

class CycleService {
  static const String _baseUrl = "http://10.0.2.2:5000/api"; // Android emulator

  // Add new cycle
  static Future<void> addCycle(
      DateTime startDate, DateTime endDate, String symptoms) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cycles'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'start_date': _formatDate(startDate),
        'end_date': _formatDate(endDate),
        'symptoms': symptoms,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add cycle: ${response.body}');
    }
  }

  // Get all cycles
  static Future<List<Cycle>> getCycles() async {
    final response = await http.get(Uri.parse('$_baseUrl/cycles'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Cycle.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load cycles');
    }
  }

  // Get prediction
  static Future<String> getPrediction() async {
    final response = await http.get(Uri.parse('$_baseUrl/predict-next'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['prediction'];
    } else {
      throw Exception('Failed to get prediction: ${response.body}');
    }
  }

  // Get ML prediction
  static Future<Map<String, dynamic>> getMLPrediction() async {
    final response = await http.get(Uri.parse('$_baseUrl/predict-next-lstm'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get ML prediction: ${response.body}');
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
