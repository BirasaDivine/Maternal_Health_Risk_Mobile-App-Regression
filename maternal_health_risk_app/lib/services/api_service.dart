import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Replace with your actual Render URL after deployment
  static const String baseUrl = 'https://your-app-name.onrender.com';
  static const String predictEndpoint = '/predict';

  /// Makes a prediction request to the API
  ///
  /// Returns a Map with the prediction result or throws an exception
  static Future<Map<String, dynamic>> makePrediction({
    required double age,
    required double diastolicBP,
    required double bs,
    required double bodyTemp,
    required double heartRate,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$predictEndpoint');

      final body = json.encode({
        'Age': age,
        'DiastolicBP': diastolicBP,
        'BS': bs,
        'BodyTemp': bodyTemp,
        'HeartRate': heartRate,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 422) {
        // Validation error
        final error = json.decode(response.body);
        throw Exception('Validation Error: ${error['detail']}');
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make prediction: $e');
    }
  }
}
