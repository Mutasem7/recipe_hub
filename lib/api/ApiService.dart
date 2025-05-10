import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  const ApiService._();

  static const ApiService instance = ApiService._();

  final String baseUrl = 'http://recipe-hub.runasp.net/api';

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      // Check for successful response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        // Log the error response for debugging
        final errorResponse = jsonDecode(response.body);
        throw Exception(
          'Failed to post data: ${response.statusCode}, Error: $errorResponse',
        );
      }
    } catch (e) {
      // Log the exception for debugging
      print('Error in POST request: $e');
      throw Exception('Error in POST request: $e');
    }
  }
}
