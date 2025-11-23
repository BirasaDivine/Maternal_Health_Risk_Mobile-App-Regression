import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String productionUrl =
      'https://github.com/BirasaDivine/Maternal_Health_Risk_Mobile-App-Regression/tree/main';

  static const String localUrl = 'http://localhost:8000';

  static const bool useProduction = false;

  static String get baseUrl => useProduction ? productionUrl : localUrl;
  static const String predictEndpoint = '/predict';
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

      print('Making API request to: $url');
      print('Request body: $body');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timeout. Please check your internet connection.',
              );
            },
          );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 422) {
        // Validation error
        final error = json.decode(response.body);
        throw Exception('Validation Error: ${error['detail']}');
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to server. $e');
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to make prediction: $e');
    }
  }
}
